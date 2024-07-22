%% load real_data
% Note: This file cannot run independently. 
% One need to download the data from the website and change the corresponding paths accordingly.
% Website for skin cancer data: https://www.isic-archive.com/ 
% Website for ADHD data: https://fcon_1000.projects.nitrc.org/indi/adhd200/


%% read skin data
Path = 'D:\skin\train\malignant';          
File = dir(fullfile(Path,'*.jpg'));  
FileNames_ma = {File.name}';            
for i=1:1:length(FileNames_ma)
    temp = double(imread([Path,'\',char(FileNames_ma(i))]))/255;
    M(:,:,:,i) = array_resize(temp,[64,64,3]);
    y(i,1) = 1;
    disp(i)
end
Path = 'D:\skin\train\benign';                  
File = dir(fullfile(Path,'*.jpg')); 
FileNames_be = {File.name}';            
for i=1:1:length(FileNames_be)
    temp = double(imread([Path,'\',char(FileNames_be(i))]))/255;
    M(:,:,:,i+length(FileNames_ma)) = array_resize(temp,[64,64,3]);
    y(i+length(FileNames_ma),1) = 0;
end
M=tensor(M);

%% read ADHD data
[label,label_str] = xlsread("adhd.xlsx",'Sheet3');
y = label(:,4);
X = label(:,1:3); % gender, hand, age

for i =1:1:length(y)
nii = load_nii(['E:\adhd\',char(label_str(i+1,1)),'_1\anat_1\NIfTI\mri\wmrest.nii']);
img = double(nii.img);
img(isnan(img))=0;
WT = wavedec3(img,4,'haar'); 
M(:,:,:,i) = WT.dec{1};
disp(i)
end
M=tensor(M);