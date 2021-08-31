%% T1 Analysis 
% Author: Rossana Terracciano
% Date: 2021-01-07
% Info: Before to run this script, be sure to:
%           1. Create a subfolder in \data for the MRI images to analyze
%           2. Upload the dicom files converted .mat in the created subfolder 
% Matlab version: R2020b


%%
clear all;close all; clc
files = dir(uigetdir);

for i=3:length(files)
    load(strcat(files(i).folder,'\',files(i).name));
end

%check number of slides (need to be the same for all of them, otherwise rescale taking into account that they are isocentric)
img_FA4 = squeeze(SAGT1_FL3D_FA4(:,:,1,:));
img_FA15 = squeeze(SAGT1_FL3D_FA15(:,:,1,:));
img_SB1 = squeeze(Signal_B1map(:,:,1,:));
J = imresize(img_SB1,[1764 968]);

%% Before to run this section:
%           1. Create a mask on the FA15 images and save as mask.mat using:
%               volumeSegmenter(img_FA15)

I_fa4 = double(img_FA4).*mask;
I_fa15 = double(img_FA15).*mask;
I_SB1 = double(J).*mask;

alpha1 = deg2rad(4); %FA=4
alpha2 = deg2rad(15); %FA=15

TR = 13; %ms
ind_T1 = 0;

T1_map = zeros(size(I_fa15,1),size(I_fa15,2),size(I_fa15,3));
h=1;
for k = 1:size(I_fa15,3)
    for i = 1:size(I_fa15,1)
        for j=1:size(I_fa15,2)
            if I_fa15(i,j,k)~=0
                S1 = I_fa4(i,j,k);
                S2 = I_fa15(i,j,k);
                fB1 = I_SB1(i,j,k)/900;
                T1_map(i,j,k) = 2*TR*(1/(fB1^2))*(((S1/alpha1)-(S2/alpha2))/((S2*alpha2)-(S1*alpha1)));
                ind_T1(h) = T1_map(i,j,k);
                h=h+1;
            end
        end
    end
end

vec=0;
for i=1:length(ind_T1)
    if ind_T1(i)<0 || ind_T1(i)>1000
        vec = [vec i];
    end
end

ind_T1(vec(2:end))=[];

figure(1), hold on, histogram(ind_T1),xlabel('T1 (ms)'),ylabel('Frequency')

%% Plot figure

%pick the best slide for the picture and save the number as slide_number:
%imshow3D(img_FA15);

slide_number = ...; %number of the slide you want to visualize
background = img_FA15(:,:,slide_number);
t1 = T1_map(:,:,slide_number);
figure1 = figure;
%Create 2 AXES ax1 and ax2 with 'f' assigned as the parent to both axes.
ax1 = axes('Parent',figure1);
ax2 = axes('Parent',figure1);
%Set the 'Visibility' property for both of these to off. 
set(ax1,'Visible','off');
set(ax2,'Visible','off');

%Display the image using IMSHOW on the first axes and store the handle in a variable 'I'.
Im=imshow(background,[],'Parent',ax2);
%  
%Set the 'AlphaData' property of 'I' to 'alpha' retrieved in the Step 3.
set(Im,'AlphaData',not(mask(:,:,slide_number)));

%  
%Display the background image on the second axis using IMSHOW. 
imshow(t1,[min(t1(:)) max(t1(:))],'Parent',ax1);
colormap(ax1,'jet'),caxis(ax1,[0, 1000]);

% %% SNR Calculation
% 
% 
% img_signal = background;
% imshow(img_signal(:,:),[])
% 
% masked_signal = img_signal.*uint16(mask(:,:,slide_number));
% %save values within the 3D mask
% ind_signal=0;
% h=1;
% 
%     for i=1:size(img_signal,1)
%         for j=1:size(img_signal,2)
%             if masked_signal(i,j)~=0
%                 ind_signal(h) = masked_signal(i,j);
%                 h=h+1;
%             end
%         end
%     end
% 
% 
% img_noise = img_signal(1400:1450,20:40);
% %save values within the 3D mask
% ind_noise=0;
% h=1;
% for k=1:size(img_noise,3)
%     for i=1:size(img_noise,1)
%         for j=1:size(img_noise,2)
%             if img_noise(i,j)~=0
%                 ind_noise(h) = img_noise(i,j);
%                 h=h+1;
%             end
%         end
%     end
% end
% 
% SNR = mean(ind_signal)/std(ind_noise)
