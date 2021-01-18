% Non-Rigid ICP implement
% Yan Song, 2018.01.18
% based on the paper : 
%    Optimal Step Nonrigid ICP Algorithms for Surface Registration
%    Another Matlab implementation: https://github.com/charlienash/nricp
%
% input
%   source.vertices: target.vertices,  N1*3, N2*3
%   source.faces   : target.faces,     M1*3, M2*3
%   out_path       : the path for saving
%   Options.gamm, Options.epsilon, Options.alphaSet, Options.maxIter
%
% output 
%   None, fitted obj file is saved in out_path
%--------------------------------------------------------------------------
function NonRigid_ICP2(source, target, out_path, Options)
    
    if ~isfield(Options, 'gamm')
        gamm = 1;
    else
        gamm = Options.gamm;
    end
    if ~isfield(Options, 'epsilon')
        epsilon = 1e-4;
    else
        epsilon = Options.epsilon;
    end
    if ~isfield(Options, 'alphaSet')
        alphaSet = linspace(100, 1, 100);
    else
        alphaSet = Options.alphaSet;
    end
    % control the maximum iteration for each alpha loop
    if ~isfield(Options, 'maxIter') 
        maxIter = 500; 
    else
        maxIter = Options.maxIter;
    end
    %----------------------------------------------------------------------
    if ~isfield(source, 'vertices') || ~isfield(source, 'faces')
        disp('   Error: no vertices or faces in source');
        return
    else
        sourceV = source.vertices;
        sourceF = source.faces;
    end
    if ~isfield(target, 'vertices') || ~isfield(target, 'faces')
        disp('   Error: no vertices or faces in target');
        return
    else
        targetV = target.vertices;
        targetF = target.faces;
    end
    % transfer the meshes to the original points, roughly alignment
    sourceV = sourceV - mean(sourceV);
    targetV = targetV - mean(targetV);
    minValue_source = min(sourceV);
    sourceV = sourceV - [0, minValue_source(2), 0];
    minValue_target = min(targetV);
    targetV = targetV - [0, minValue_target(2), 0];
    %----------------------------------------------------------------------
    nVertsSource = size(sourceV, 1);
    nAlpha = numel(alphaSet);
    G = diag([1 1 1 gamm]);
    A = triangulation2adjacency(sourceF, sourceV);
    M = adjacency2incidence(A)';
    kron_M_G = kron(M, G);
    bdr = find_bound(targetV, targetF);
    X = repmat([eye(3); [0 0 0]], nVertsSource, 1);
    D = sparse(nVertsSource, 4 * nVertsSource);
    for i = 1:nVertsSource
        D(i,(4 * i-3):(4 * i)) = [sourceV(i,:) 1];
    end
    %----------------------------------------------------------------------
    for i = 1:nAlpha
        alpha = alphaSet(i);
        iter = 0;
        oldX = 10*X;
        while norm(X - oldX) >= epsilon
%             disp(norm(X-oldX));
            vertsTransformed = D*X;
            % for NOMO scans find the corresponding points
            targetId = knnsearch(targetV, vertsTransformed);
            targetId = targetId';
            U = targetV(targetId,:);
            % for SMOL mesh
%             targetId = 1:6890;
%             U = targetV;
            %------------------------
            % boarder detection
            tarBoundary = ismember(targetId, bdr);
            wVec = ~tarBoundary;
            %-----------------------
            W = spdiags(wVec', 0, nVertsSource, nVertsSource); % ????
            %-----------------------
            A = [...
                    alpha .* kron_M_G; 
                    W * D;
                ];
            B = [...
                    zeros(size(M,1)*size(G,1), 3);
                    W * U;
                ];

            oldX = X;
            X = (A' * A) \ (A' * B);
            
            iter = iter + 1;
            if iter == maxIter  % if can not converge in maxIter 
                disp([' the norm(X-oldX) = ' num2str(norm(X - oldX))]);
                break;
            end
            
        end
    end
    %----------------------------------------------------------------------
    registeredV = D*X;
    saveObj(out_path, full(registeredV), sourceF);
end
