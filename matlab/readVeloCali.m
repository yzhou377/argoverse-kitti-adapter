function [P,R0_rect,Velo2Cam] = readVeloCali(calib_dir,img_idx,cam)
  P_all = dlmread(sprintf('%s/%06d.txt',calib_dir,img_idx),' ',0,1);
  P = reshape(P_all(cam+1,:),[4,3])';
  R0_rect = reshape(P_all(5,1:9),[3,3])';
  R0_rect = [[R0_rect,zeros(3,1)];[zeros(1,3),1]];
  Velo2Cam = reshape(P_all(6,:),[4,3])';
  Velo2Cam = [Velo2Cam;0,0,0,1];
end