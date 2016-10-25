clc;clear all;close all;
I = eye(1024,1024);
regfactor = 1/2;
sum1 = zeros(1024,1);
for i=1:200
    path1= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\1\';
    fname=strcat(path1,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    im = im(:);
    im = im2double(im);
    sum1 = sum1 + im;
end
mean1 = sum1 / 200;
% case 1
%Generating co-variance matrix for a class 1
sum2 = 0;
for i=1:200
    path1= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\1\';
    fname=strcat(path1,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    im = im(:);
    im = im2double(im);
    sum2 = sum2 + (im - mean1)*(im - mean1)';
end
cov1 = sum2 / 200;
cov1 = cov1 + regfactor * I;

sum3 = zeros(1024,1);
for i=1:200
    path2= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\2\';
    fname=strcat(path2,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    im = im(:);
    im = im2double(im);
    sum3 = sum3 + im;
end
mean2 = sum3 / 200;
% case 1
%Generating co-variance matrix for a class 1
sum4 = 0;
for i=1:200
    path2= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\2\';
    fname=strcat(path2,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    im = im(:);
    im = im2double(im);
    sum4 = sum4 + (im - mean2)*(im - mean2)';
end
cov2 = sum4 / 200;
cov2 = cov2 + regfactor * I;

sum5 = zeros(1024,1);
for i=1:200
    path3= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\3\';
    fname=strcat(path3,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    
    im = im(:);
    im = im2double(im);
    sum5 = sum5 + im;
end
mean3 = sum5 / 200;
% case 1
%Generating co-variance matrix for a class 1
sum6 = 0;
for i=1:200
    path3= 'D:\PRML\Problems\Assignment_list\TrainCharacters\TrainCharacters\3\';
    fname=strcat(path3,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);
    
    im = im(:);
    im = im2double(im);
    sum6 = sum6 + (im - mean2)*(im - mean2)';
end
cov3 = sum6 / 200;
cov3 = cov3 + regfactor * I;

f = @Maximum_Likelihood;
% I am neglecting priors, because they are equal, so I am calculating just
% likelihoods
% For class 1 testing samples
counter1 = 0;
counter2 = 0;
counter3 = 0;
for i=201:300
    path1 = 'D:\PRML\Problems\Assignment_list\TestCharacters\TestCharacters\TestCharacters\1\';
    fname=strcat(path1,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);    
    im = im(:);
    im = im2double(im);
     m =  f(double(im),mean1,cov1);
     n =  f(double(im),mean2,cov2);
     o =  f(double(im),mean3,cov3);
     ml(1) = m;
     ml(2) = n;
     ml(3) = o;
     [H,ind] = max(ml);
     if(ind == 1)
         counter1 = counter1 + 1;
     elseif(ind == 2)
         counter2 = counter2 + 1;
         fprintf('%d image is miss classified into class 2 where its true nature is class 1.\n',i);
     else
         counter3 = counter3 + 1;
         fprintf('%d image is miss classified into class 3 where its true nature is class 1.\n',i);
     end
end
Accuracy1 = counter1/100;
%For class 2 Testing samples
counter1 = 0;
counter2 = 0;
counter3 = 0;
for i=201:300
    path2 = 'D:\PRML\Problems\Assignment_list\TestCharacters\TestCharacters\TestCharacters\2\';
    fname=strcat(path2,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);    
    im = im(:);
    im = im2double(im);
     m =  f(im,mean1,cov1);
     n =  f(im,mean2,cov2);
     o =  f(im,mean3,cov3);
     
     ml(1) = m;
     ml(2) = n;
     ml(3) = o;
     [H,ind] = max(ml);
     if(ind == 1)
         counter1 = counter1 + 1;
         fprintf('%d image in test samples of class 2 is miss classified into class 1.\n',i);
     elseif(ind == 2)
         counter2 = counter2 + 1;
     else
         counter3 = counter3 + 1;
         fprintf('%d image in test samples of class 2 is miss classified into class 3.\n',i);
     end
end
Accuracy2 = counter2/100;
%For class 3 Testing samples
counter1 = 0;
counter2 = 0;
counter3 = 0;
for i=201:300
    path3 = 'D:\PRML\Problems\Assignment_list\TestCharacters\TestCharacters\TestCharacters\3\';
    fname=strcat(path3,num2str(i),'.jpg');
    im=imread(fname);
    im=imresize(im,0.25);    
    im = im(:);
    im = im2double(im);
     m =  f(im,mean1,cov1);
     n =  f(im,mean2,cov2);
     o =  f(im,mean3,cov3);
     ml(1) = m;
     ml(2) = n;
     ml(3) = o;
     [H,ind] = max(ml);
     if(ind == 1)
         counter1 = counter1 + 1;
         fprintf('%d image in test samples of class 3 is miss classified into class 1.\n',i);
     elseif(ind == 2)
         counter2 = counter2 + 1;
         fprintf('%d image in test samples of class 3 is miss classified into class 2.\n',i);
     else
         counter3 = counter3 + 1;
     end
end
Accuracy3 = counter3/100;

AvgAccuracy = (Accuracy1 + Accuracy2 + Accuracy3)/3;

