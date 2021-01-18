
clear ; close all; clc;

load('gt.mat');

objGT = struct();

for ii = 1:194
    objGT(ii).name = objList(ii).name;
    objGT(ii).HIP_Circ = [];
    objGT(ii).Seat_Back_Angle = [];
    objGT(ii).Calf_Left = [];
    objGT(ii).Calf_Right = [];
    objGT(ii).Across_Back = [];
    objGT(ii).NeckBase_Circ = [];
    objGT(ii).CHEST_Circ = [];
    objGT(ii).Neck_Circ = [];
    objGT(ii).TrouserWaist_Height_Back = [];
    objGT(ii).TrouserWAIST_Circ = objList(ii).waist_circ;
    objGT(ii).MaxWAIST_Circ = [];
    objGT(ii).Shoulder_to_Shoulder = [];
    objGT(ii).Across_Front = [];
    objGT(ii).CrotchLength_Front = [];
    objGT(ii).CrotchLength_Back = [];
    objGT(ii).Thigh_Circ = [];
    objGT(ii).Knee_Circ = [];
    objGT(ii).Calf_Circ = [];
    objGT(ii).Outseam = [];
    objGT(ii).Inseam = [];
    objGT(ii).Knee_Height = [];
    objGT(ii).Shoulder_Length = [];
    objGT(ii).Shoulder_to_Wrist = [];
    objGT(ii).Bicep_Circ = [];
    objGT(ii).Elbow_Circ = [];
    objGT(ii).Wrist_Circ = [];
    objGT(ii).Shoulder_Slope_Left = [];
    objGT(ii).Shoulder_Slope_Right = [];
    objGT(ii).Joints = [];
    objGT(ii).Landmarks = [];
    objGT(ii).CROTCH_Height = [];
    objGT(ii).Head_Top_Height = [];
    objGT(ii).NECK_Height = [];
    objGT(ii).MaxWaist_Height = [];
    objGT(ii).TrouserWaist_Height_Front = [];
    objGT(ii).Ankle_Girth_Left = [];
    objGT(ii).Ankle_Girth_Right = [];
    objGT(ii).Calf_Height = [];
    objGT(ii).Ankle_Height = [];
    objGT(ii).Ankle_Circ = [];
    objGT(ii).Thigh_Height = [];
    objGT(ii).Shoulder_Width_thruTheBody = [];
    objGT(ii).Hip_Width_ThruTheBody = [];
    objGT(ii).Overarm_Width_ThruTheBody = [];
    
end
    


%%



clear; close all; clc;


load('objGT.mat');
ordPath = '/home/yan/Data2/NOMO_project/Measurement/measurement_GT/Files.fm_Male_ORD/';
ordFiles = dir([ordPath '*.ord']);

for ii = 1:194
    objName = objGT(ii).name;
    C = strsplit(objName, ' ');
    match_str = [C{1} '+' C{2}];
    for jj = 1:size(ordFiles, 1)
        if contains(ordFiles(jj).name, match_str)
            fid = fopen([ordPath ordFiles(jj).name]);
            tline = fgetl(fid);
            while ischar(tline)
                if contains(tline, 'MEASURE HIP_Circ=')
                    objGT(ii).HIP_Circ = str2double(tline(18:end));
                end
                if contains(tline, 'MEASURE Seat_Back_Angle=')
                    objGT(ii).Seat_Back_Angle = str2double(tline(25:end));
                end
                if contains(tline, 'MEASURE Calf_Left=')
                    objGT(ii).Calf_Left = str2double(tline(19:end));
                end
                if contains(tline, 'MEASURE Calf_Right=')
                    objGT(ii).Calf_Right = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Across_Back=')
                    objGT(ii).Across_Back = str2double(tline(21:end));
                end
                if contains(tline, 'MEASURE NeckBase_Circ=')
                    objGT(ii).NeckBase_Circ = str2double(tline(23:end));
                end
                if contains(tline, 'MEASURE CHEST_Circ=')
                    objGT(ii).CHEST_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Neck_Circ=')
                    objGT(ii).Neck_Circ = str2double(tline(19:end));
                end
                if contains(tline, 'MEASURE TrouserWaist_Height_Back=')
                    objGT(ii).TrouserWaist_Height_Back = str2double(tline(34:end));
                end
                if contains(tline, 'MEASURE TrouserWAIST_Circ=')
                    objGT(ii).TrouserWAIST_Circ = str2double(tline(27:end));
                end
                if contains(tline, 'MEASURE MaxWAIST_Circ=')
                    objGT(ii).MaxWAIST_Circ = str2double(tline(23:end));
                end
                if contains(tline, 'MEASURE Shoulder_to_Shoulder=')
                    objGT(ii).Shoulder_to_Shoulder = str2double(tline(30:end));
                end
                if contains(tline, 'MEASURE Across_Front=')
                    objGT(ii).Across_Front = str2double(tline(22:end));
                end
                if contains(tline, 'MEASURE CrotchLength_Front=')
                    objGT(ii).CrotchLength_Front = str2double(tline(28:end));
                end
                if contains(tline, 'MEASURE CrotchLength_Back=')
                    objGT(ii).CrotchLength_Back = str2double(tline(27:end));
                end
                if contains(tline, 'MEASURE Thigh_Circ=')
                    objGT(ii).Thigh_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Knee_Circ=')
                    objGT(ii).Knee_Circ = str2double(tline(19:end));
                end
                if contains(tline, 'MEASURE Calf_Circ=')
                    objGT(ii).Calf_Circ = str2double(tline(19:end));
                end
                if contains(tline, 'MEASURE Outseam=')
                    objGT(ii).Outseam = str2double(tline(17:end));
                end
                if contains(tline, 'MEASURE Inseam=')
                    objGT(ii).Inseam = str2double(tline(16:end));
                end
                if contains(tline, 'MEASURE Knee_Height=')
                    objGT(ii).Knee_Height = str2double(tline(21:end));
                end
                if contains(tline, 'MEASURE Shoulder_Length=')
                    objGT(ii).Shoulder_Length = str2double(tline(25:end));
                end
                if contains(tline, 'MEASURE Shoulder_to_Wrist=')
                    objGT(ii).Shoulder_to_Wrist = str2double(tline(27:end));
                end
                if contains(tline, 'MEASURE Bicep_Circ=')
                    objGT(ii).Bicep_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Elbow_Circ=')
                    objGT(ii).Elbow_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Wrist_Circ=')
                    objGT(ii).Wrist_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Shoulder_Slope_Left=')
                    objGT(ii).Shoulder_Slope_Left = str2double(tline(29:end));
                end
                if contains(tline, 'MEASURE Shoulder_Slope_Right=')
                    objGT(ii).Shoulder_Slope_Right = str2double(tline(30:end));
                end
                if contains(tline, 'MEASURE Joints=')
                    objGT(ii).Joints = str2double(tline(16:end));
                end
                if contains(tline, 'MEASURE Landmarks=')
                    objGT(ii).Landmarks = str2double(tline(19:end));
                end
                if contains(tline, 'MEASURE CROTCH_Height=')
                    objGT(ii).CROTCH_Height = str2double(tline(23:end));
                end
                if contains(tline, 'MEASURE Head_Top_Height=')
                    objGT(ii).Head_Top_Height = str2double(tline(25:end));
                end
                if contains(tline, 'MEASURE NECK_Height=')
                    objGT(ii).NECK_Height = str2double(tline(21:end));
                end
                if contains(tline, 'MEASURE MaxWaist_Height=')
                    objGT(ii).MaxWaist_Height = str2double(tline(25:end));
                end
                if contains(tline, 'MEASURE TrouserWaist_Height_Front=')
                    objGT(ii).TrouserWaist_Height_Front = str2double(tline(35:end));
                end
                if contains(tline, 'MEASURE Ankle_Girth_Left=')
                    objGT(ii).Ankle_Girth_Left = str2double(tline(26:end));
                end
                if contains(tline, 'MEASURE Ankle_Girth_Right=')
                    objGT(ii).Ankle_Girth_Right = str2double(tline(27:end));
                end
                if contains(tline, 'MEASURE Calf_Height=')
                    objGT(ii).Calf_Height = str2double(tline(21:end));
                end
                if contains(tline, 'MEASURE Ankle_Height=')
                    objGT(ii).Ankle_Height = str2double(tline(22:end));
                end
                if contains(tline, 'MEASURE Ankle_Circ=')
                    objGT(ii).Ankle_Circ = str2double(tline(20:end));
                end
                if contains(tline, 'MEASURE Thigh_Height=')
                    objGT(ii).Thigh_Height = str2double(tline(22:end));
                end
                if contains(tline, 'MEASURE Shoulder_Width_thruTheBody=')
                    objGT(ii).Shoulder_Width_thruTheBody = str2double(tline(36:end));
                end
                if contains(tline, 'MEASURE Hip_Width_ThruTheBody=')
                    objGT(ii).Hip_Width_ThruTheBody = str2double(tline(31:end));
                end
                if contains(tline, 'MEASURE Overarm_Width_ThruTheBody=')
                    objGT(ii).Overarm_Width_ThruTheBody = str2double(tline(35:end));
                end
                tline = fgetl(fid);
            end
            fclose(fid);
        end
    end
end










