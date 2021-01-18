clear all; close all; clc;

female_measurement_gt = struct();

scan_list = dir('/home/yan/Data2/NOMO_Project/data/TC2_scan_mesh/TC2_female_m/*.obj');
ord_list = dir('/home/yan/Data2/NOMO_Project/data/measurement_GT/TC2_Female_ORD/*.ord');

for ii = 1:length(ord_list)
    name = ord_list(ii).name;
    female_measurement_gt(ii).name = name(1:end-4);
    fid = fopen(['/home/yan/Data2/NOMO_Project/data/measurement_GT/TC2_Female_ORD/' name]);
    tline = fgetl(fid);
    while ischar(tline)
        if contains(tline, 'MEASURE Seat_Back_Angle=')
            female_measurement_gt(ii).Seat_Back_Angle =str2double(tline(25:end));
        end
        if contains(tline, 'MEASURE Outseam=')
            female_measurement_gt(ii).Outseam =str2double(tline(17:end));
        end
        if contains(tline, 'MEASURE Inseam=')
            female_measurement_gt(ii).Inseam =str2double(tline(16:end));
        end
        if contains(tline, 'MEASURE CROTCH_Height=')
            female_measurement_gt(ii).CROTCH_Height =str2double(tline(23:end));
        end
        if contains(tline, 'MEASURE TrouserWAIST_Circ=')
            female_measurement_gt(ii).TrouserWAIST_Circ =str2double(tline(27:end));
        end
        if contains(tline, 'MEASURE HIP_Circ=')
            female_measurement_gt(ii).HIP_Circ =str2double(tline(18:end));
        end
        if contains(tline, 'MEASURE Knee_Height=')
            female_measurement_gt(ii).Knee_Height =str2double(tline(21:end));
        end
        if contains(tline, 'MEASURE Calf_Height=')
            female_measurement_gt(ii).Calf_Height =str2double(tline(21:end));
        end
        if contains(tline, 'MEASURE Waist_Height_Back_EZ=')
            female_measurement_gt(ii).Waist_Height_Back_EZ =str2double(tline(30:end));
        end
        if contains(tline, 'MEASURE TrouserWaist_Height_Back=')
            female_measurement_gt(ii).TrouserWaist_Height_Back =str2double(tline(34:end));
        end
        if contains(tline, 'MEASURE CrotchLength_Back=')
            female_measurement_gt(ii).CrotchLength_Back =str2double(tline(27:end));
        end
        if contains(tline, 'MEASURE CrotchLength_Front=')
            female_measurement_gt(ii).CrotchLength_Front =str2double(tline(28:end));
        end
        if contains(tline, 'MEASURE Ankle_Circ=')
            female_measurement_gt(ii).Ankle_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Head_Top_Height=')
            female_measurement_gt(ii).Head_Top_Height =str2double(tline(25:end));
        end
        if contains(tline, 'MEASURE Hip_Height=')
            female_measurement_gt(ii).Hip_Height =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE NeckBase_Circ=')
            female_measurement_gt(ii).NeckBase_Circ =str2double(tline(23:end));
        end
        if contains(tline, 'MEASURE Bust_to_Bust=')
            female_measurement_gt(ii).Bust_to_Bust =str2double(tline(22:end));
        end
        if contains(tline, 'MEASURE Underbust_Circ=')
            female_measurement_gt(ii).Underbust_Circ =str2double(tline(24:end));
        end
        if contains(tline, 'MEASURE BUST_Circ=')
            female_measurement_gt(ii).BUST_Circ =str2double(tline(19:end));
        end
        if contains(tline, 'MEASURE Across_Back=')
            female_measurement_gt(ii).Across_Back =str2double(tline(21:end));
        end
        if contains(tline, 'MEASURE Shoulder_to_Shoulder=')
            female_measurement_gt(ii).Shoulder_to_Shoulder =str2double(tline(30:end));
        end
        if contains(tline, 'MEASURE Neck_Circ=')
            female_measurement_gt(ii).Neck_Circ =str2double(tline(19:end));
        end
        if contains(tline, 'MEASURE Knee_Circ=')
            female_measurement_gt(ii).Knee_Circ =str2double(tline(19:end));
        end
        if contains(tline, 'MEASURE Calf_Circ=')
            female_measurement_gt(ii).Calf_Circ =str2double(tline(19:end));
        end
        if contains(tline, 'MEASURE Bicep_Circ=')
            female_measurement_gt(ii).Bicep_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Elbow_Circ=')
            female_measurement_gt(ii).Elbow_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Wrist_Circ=')
            female_measurement_gt(ii).Wrist_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Shoulder_to_Wrist=')
            female_measurement_gt(ii).Shoulder_to_Wrist =str2double(tline(27:end));
        end
        if contains(tline, 'MEASURE Shoulder_Length=')
            female_measurement_gt(ii).Shoulder_Length =str2double(tline(25:end));
        end
        if contains(tline, 'MEASURE SideNeck_to_Bust=')
            female_measurement_gt(ii).SideNeck_to_Bust =str2double(tline(26:end));
        end
        if contains(tline, 'MEASURE NeckSide_to_Wrist=')
            female_measurement_gt(ii).NeckSide_to_Wrist =str2double(tline(27:end));
        end
        if contains(tline, 'MEASURE NECK_Height=')
            female_measurement_gt(ii).NECK_Height =str2double(tline(21:end));
        end
        if contains(tline, 'MEASURE Thigh_Circ=')
            female_measurement_gt(ii).Thigh_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Across_Front=')
            female_measurement_gt(ii).Across_Front =str2double(tline(22:end));
        end
        if contains(tline, 'MEASURE Shoulder_to_floor_Right=')
            female_measurement_gt(ii).Shoulder_to_floor_Right =str2double(tline(33:end));
        end
        if contains(tline, 'MEASURE Shoulder_to_floor_Left=')
            female_measurement_gt(ii).Shoulder_to_floor_Left =str2double(tline(32:end));
        end
        if contains(tline, 'MEASURE TopHip_Circ=')
            female_measurement_gt(ii).TopHip_Circ =str2double(tline(21:end));
        end
        if contains(tline, 'MEASURE TrouserWaist_Height_Front=')
            female_measurement_gt(ii).TrouserWaist_Height_Front =str2double(tline(35:end));
        end
         if contains(tline, 'MEASURE Bust_Height=')
            female_measurement_gt(ii).Bust_Height =str2double(tline(21:end));
         end
         if contains(tline, 'MEASURE Torso_Height=')
            female_measurement_gt(ii).Torso_Height =str2double(tline(22:end));
         end
         if contains(tline, 'MEASURE Istumakorkeus=')
            female_measurement_gt(ii).Istumakorkeus =str2double(tline(23:end));
         end
         if contains(tline, 'MEASURE NaturalWAIST_Circ=')
            female_measurement_gt(ii).NaturalWAIST_Circ =str2double(tline(27:end));
         end
         if contains(tline, 'MEASURE NaturalWaist_Height=')
            female_measurement_gt(ii).NaturalWaist_Height =str2double(tline(29:end));
         end
         if contains(tline, 'MEASURE Thigh_Height=')
            female_measurement_gt(ii).Thigh_Height =str2double(tline(22:end));
         end
         if contains(tline, 'MEASURE Ankle_Height=')
            female_measurement_gt(ii).Ankle_Height =str2double(tline(22:end));
         end
         if contains(tline, 'MEASURE Shoulder_Width_ThruTheBody=')
            female_measurement_gt(ii).Shoulder_Width_ThruTheBody =str2double(tline(36:end));
         end
         if contains(tline, 'MEASURE Overarm_Width_ThruTheBody=')
            female_measurement_gt(ii).Overarm_Width_ThruTheBody =str2double(tline(35:end));
         end
        if contains(tline, 'MEASURE Hip_2_Width_ThruTheBody=')
            female_measurement_gt(ii).Hip_2_Width_ThruTheBody =str2double(tline(33:end));
        end
        if contains(tline, 'MEASURE Hip_2_Circ=')
            female_measurement_gt(ii).Hip_2_Circ =str2double(tline(20:end));
        end
        if contains(tline, 'MEASURE Hip_2_Height=')
            female_measurement_gt(ii).Hip_2_Height =str2double(tline(22:end));
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end