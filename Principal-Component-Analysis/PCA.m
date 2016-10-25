clc; 
clear all;close all;
workspace;  
format long g;
format compact;
% Define a starting folder.
start_path = fullfile(matlabroot, 'D:\PRML\Problems\Assignment_list\gallery\gallery\');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)
%For calculating the mean 
% Processing all the image files in those folders.
sum = zeros(10304,1);
X = zeros(10304,200);p =1;
Big = zeros(112,92*200);

for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
	% Get PNG files.
	filePattern = sprintf('%s/*.pgm', thisFolder);
	baseFileNames = dir(filePattern);
	numberOfImageFiles = length(baseFileNames);
	% Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		% Go through all those image files.
		for f = 1 : numberOfImageFiles
			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
% 			fprintf('     Processing image file %s\n', fullFileName);
             i =imread(fullFileName);
             d = (92*(p-1) + 1):92*p;
             Big(:,d) = i;
              b = i(:);
              sum = sum + double(b);
             X(:,p) = b;
             p = p + 1;
		end
	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
	end
end
mean = sum /200;
A = zeros(10304,200);
p =1;
for i = 1:200
    A(:,p) = X(:,p) - mean;
    p = p + 1;
end
F = A' * A;
V = F /200;
[V,D] = eig(V);
S = zeros(1,200);
% S = S/sum(S);
summyt = 0;
for i =1:200
    summyt = summyt + D(i,i);
    S(1,i) = D(i,i);
end
    
[H,I] = sort(S);
perc = 0;
summy =0;
j = 0;
for i = 200:-1:1
        summy = summy + H(i);
        perc = (summy / summyt)*100;
        plot(i,perc,'*')
        hold on
        if (perc < 95)
            j = j + 1;
        end
end
fprintf('To capture 95 percent variance, we required %d values\n',j)
%Displaying the image correspond to highest eigen value
figure
%After = A * V;
for i = 1:200
    After(:,i) = A*V(:,i);    
    After(:,i) = After(:,i)/norm(After(:,i));
end
colormap gray
imagesc(reshape(After(:,I(200)),112,92))
%Displaying the images corresponding to top 5 eigen values
figure;
colormap gray
for i =1:5
    subplot(2, ceil(5/2), i);
    imagesc(reshape(After(:,I(201-i)),112,92))
end
f = 1;
while(f<3)
 original = 0;
[Name,PathName] = uigetfile('*.pgm','select the face input image file');
fac1 = imread(strcat(PathName,Name));
fac1 = fac1(:);
fac1 = double(fac1);
% diff = fac1 - mean;
% sum =0;
% for i=1:10304
%     sum = sum + diff(i,1)*diff(i,1);
% end
% original = sqrt(sum);
    
figure
colormap gray
imagesc(reshape(fac1,112,92))

%Reconstructing the image from top eigen face
y = double(fac1) - mean;
w =  y' * After(:,I(200)) ;
fac_1 = w *After(:,I(200))';
diff = double(fac_1) - fac1';
sum =0;
for i=1:10304
    sum = sum + diff(1,i)*diff(1,i);
end
error = sqrt(sum);
fprintf('Mean Square error for top eigen face is %d\n',error)
figure;
colormap gray
imagesc(reshape(fac_1,112,92))
%Reconstructing the image from top 15 eigen values
figure;
colormap gray
w1 = y' * After(:,200:-1:186);
fac_11 = w1 * After(:,200:-1:186)';
diff = double(fac_11) - fac1';
sum =0;
for i=1:10304
    sum = sum + diff(1,i)*diff(1,i);
end
error = sqrt(sum);
fprintf('Mean Square error for top 15 eigen face is %d\n',error)
imagesc(reshape(fac_11,112,92))
%Reconstructing the image from 200 eigen values
figure;
colormap gray
w2 = y' * After(:,1:200);
fac_12 = w2 * After(:,1:200)';
diff = double(fac_12) - fac1';
sum =0;
for i=1:10304
    sum = sum + diff(1,i)*diff(1,i);
end
error = sqrt(sum);
fprintf('Mean Square error for 200 eigen face is %d\n',error)
imagesc(reshape(fac_12,112,92))
figure;
%Calculation of error
for j = 1:200
    fac_13 = zeros(112*92,1);
    w3 = y' * After(:,200:-1:201-j);
    fac_13 = w3 * After(:,200:-1:201-j)';
    diff = double(fac_13) - fac1';
    sum =0;
    for i=1:10304
        sum = sum + diff(1,i)*diff(1,i);
    end
    error = sqrt(sum);
    plot(j,error,'*')
    hold on    
end
        
f = f+1;
end
