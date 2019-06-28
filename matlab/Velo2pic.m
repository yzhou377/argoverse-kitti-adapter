base_dir = '/home/exx/Desktop/Lens_Project/RPN/mscnn-master/data';
velo_dir = [base_dir,'/testing/velodyne'];
calib_dir = [base_dir,'/testing/calib'];
cam_dir = [base_dir,'/testing/image_2'];
velo_img_dir = [base_dir,'/testing/velo_img'];
cam = 2; %left color camera
nvelos = length(dir(fullfile(velo_dir, '*.bin')));
P = zeros(3,4,nvelos);
R0_rect = zeros(4,4,nvelos);
Velo2Cam = zeros(4,4,nvelos);
P_velo_to_img = zeros(3,4,nvelos);
for img_idx = 1:nvelos
    [P(:,:,img_idx),R0_rect(:,:,img_idx),Velo2Cam(:,:,img_idx)] = readVeloCali(calib_dir,img_idx,cam);
    P_velo_to_img(:,:,img_idx) = P(:,:,img_idx)*R0_rect(:,:,img_idx)*Velo2Cam(:,:,img_idx);
    fid = fopen(sprintf('%s/%06d.bin',velo_dir,img_idx),'rb');
    Velo = fread(fid,[4 inf],'single')';
    velo_img = projectToImage(Velo(:,1:3)',P_velo_to_img(:,:,img_idx))';
    depth = Velo(:,1);
    fclose(fid);
    fwid = fopen(sprintf('%s/%06d.bin',velo_img_dir,img_idx),'w+');
    fwrite(fwid,[velo_img,depth]','single','b');
    fclose(fwid);
    % plot points
    cols = jet;
    
%     close all;
%     figure(1); hold on;
%     for i=1:5:size(velo_img,1)
%         if Velo(i,1)>5 %&& Velo(i,1)<20
%             col_idx = round(64*5/Velo(i,1));
%             plot(velo_img(i,1),-velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
%             xlim([-2000,2000])
%         end;
%     end
end;

fid = fopen(sprintf('%s/%06d.bin',velo_img_dir,img_idx),'rb');
velo_img_read = fread(fid,[4 inf],'single')';