%% T2 Analysis 
% Author: Rossana Terracciano
% Date: 2021-01-07
% Info: Before to run this script, be sure to:
%           1. Create a subfolder in \data for the MRI images to analyze
%           2. Upload the dicom files converted .mat in the created subfolder 

% Matlab version: R2020b
%%
clear all;close all; clc; warning off
files = dir(uigetdir);

for i=3:length(files)
    load(strcat(files(i).folder,'\',files(i).name));
end

% Check if TE are correct:
TE = [11.1,22.2,33.3,44.4];

%check if the number of slices is 32:
img_TE_1 = squeeze(multiEchos(:,:,1,1:32));
img_TE_2 = squeeze(multiEchos(:,:,1,33:64));
img_TE_3 = squeeze(multiEchos(:,:,1,65:96));
img_TE_4 = squeeze(multiEchos(:,:,1,97:128));

%% Before running this section, be sure you have a mask. If you don't have one:
%           1. Create a mask on the FA15 images and save as mask.mat using:
%               volumeSegmenter(img_TE_1)

I = zeros(size(img_TE_1,1),size(img_TE_1,2), length(TE));
x = TE(2:end);
T2_value = zeros(size(img_TE_1,1),size(img_TE_1,2),size(img_TE_1,3));
h=1;
R=0;
ind_T2 =0;
for k = 1:size(img_TE_1,3)
    
    if sum(sum(mask(:,:,k)))~=0
        I(:,:,1) = double(img_TE_1(:,:,k)).*mask(:,:,k);
        I(:,:,2) = double(img_TE_2(:,:,k)).*mask(:,:,k);
        I(:,:,3) = double(img_TE_3(:,:,k)).*mask(:,:,k);
        I(:,:,4) = double(img_TE_4(:,:,k)).*mask(:,:,k);

        for i = 1:size(I,1)
            for j=1:size(I,2)
                if I(i,j,1)~=0
                    y = squeeze(I(i,j,2:end))';
                    [fitresult, gof] = createFit_T2(x, y);
                    coeffvals= coeffvalues(fitresult);
                    if gof.rsquare>0.9 && 1/coeffvals(2)<100
                        T2_value(i,j,k)=1/coeffvals(2);
                        ind_T2(h) = T2_value(i,j,k);
                        R(h) = gof.rsquare;
                        h=h+1;
                    end
                end
            end
        end
    end

end
histogram(ind_T2,40,'BinLimits',[0 100]),xlabel('T2 (ms)'),ylabel('Frequency')



%% Plot figure

%pick the best slide for the picture and save the number as slide_number:
%imshow3D(img_TE_1);

slide_number = ...; % number of the slide you want to visualize
background = img_TE_1(:,:,slide_number);
t2 = T2_value(:,:,slide_number);
%imshow(t2,[]),colormap('jet'),colorbar(),caxis([0, 100]);

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
imshow(t2,[min(t2(:)) max(t2(:))],'Parent',ax1);
colormap(ax1,'jet'),caxis(ax1,[0, 100]);