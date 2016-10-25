 clc;
 clear all;
 close all
 [fname,path]=uigetfile('*.jpg');
 fname=strcat(path,fname);
 e = imread(fname);
 e = double(e);
 e = e/255;
% e = double(e);
 a = e(:,1:481);
 b = e(:,482:962);
 c = e(:,963:1443);
 %Given Data
 mean1 = [120;120;120];
 mean2 = [12;12;12];
 mean3 = [180;180;180];
 cov1 = eye(3);
 cov2 = eye(3);
 cov3 = eye(3);
 m1 = mean1/255;
 m2 = mean2/255;
 m3 = mean3/255;
 %Assuming priors to be equal
 pr(1) = 1/3;
 pr(2) = 1/3;
 pr(3) = 1/3;
 %Initilaizing a matrix to store the indices
 %Making sums and counters to zero which will help in to calculate the
 %numbers of pixels fall into a particular class
 %Function for Gaussian Distribution
 u = @Gaussian_Distribution;
 
counter = 0;

k = zeros(3,481*321);
while(counter < 60)
p = 1;
count = 1;
C= zeros(321,481,3);
Res = zeros(3,481*321);
 for i = 1:321
     for j = 1:481        
         A = [e(i,j);e(i,j+481);e(i,j + 962)];
         m = pr(1) * u(A,m1,cov1);
         n = pr(2) * u(A,m2,cov2);
         o = pr(3) * u(A,m3,cov3);
         s = m + n + o;
         Res(1,p) = m/s;
         Res(2,p) = n/s;
         Res(3,p) = o/s;
         [H,ind] = max(Res(:,p));
         p = p + 1;
         if(ind == 1)
             C(i,j,1) = 1;
             count = count + 1;
         elseif(ind == 2)
             C(i,j,2) = 1;
             count = count + 1;
         else
             C(i,j,3) = 1;
             count = count + 1;
         end
     end
 end
 
%  fg = reshape(C(1,:),321,481);
%  fh = reshape(C(2,:),321,481);
%  fj = reshape(C(3,:),321,481);
%  f = [fg fh fj];
%  imagesc(f)
 %calculating prior probability
 summy1 = 0;
 summy2 = 0;
 summy3 = 0;
 p = 1;
 for i = 1:321
     for j = 1:481
             summy1 = summy1 + Res(1,p);
             summy2 = summy2 + Res(2,p);
             summy3 = summy3 + Res(3,p);
         p = p + 1;         
     end
 end
 

         pr(1) = summy1/(321*481);
         pr(2) = summy2/(321*481);
         pr(3) = summy3/(321*481);
%Prior probabilities is done;
%Calculating Mean for all the three classes
meansum1 = zeros(3,1);
meansum2 = zeros(3,1);
meansum3 = zeros(3,1);
p = 1;
for i = 1:321
     for j = 1:481
         A = [e(i,j);e(i,j+481);e(i,j + 962)];
         meansum1 = meansum1 + (Res(1,p) * A);
         meansum2 = meansum2 + (Res(2,p) * A);
         meansum3 = meansum3 + (Res(3,p) * A);
         p = p + 1;         
     end
end

         mean1 = meansum1/summy1;
         mean2 = meansum2/summy2;
         mean3 = meansum3/summy3;
 %Building co - variance matrix;
 covsum1 = zeros(3,3);
 covsum2 = zeros(3,3);
 covsum3 = zeros(3,3);
 p = 1;
for i = 1:321
     for j = 1:481
         A = [e(i,j);e(i,j+481);e(i,j + 962)];
         covsum1 = covsum1 + Res(1,p) * (A - mean1)*(A - mean1)';
         covsum2 = covsum2 + Res(2,p) * (A - mean2)*(A- mean2)';
         covsum3 = covsum3 + Res(3,p) * (A - mean3)*(A - mean3)';
         p = p + 1;         
     end
 end
 cov1 = covsum1 / summy1;
 cov2 = covsum2 / summy2;
 cov3 = covsum3 / summy3;

  
 %Evaluating the loglikelihood
 m1 = mean1;
 m2 = mean2;
 m3 = mean3;
 
 
 lsum = 0;
for i = 1:321
    for j = 1:481
         A = [e(i,j);e(i,j+481);e(i,j + 962)];
         mm = pr(1) * u(A,m1,cov1);
         nn = pr(2) * u(A,m2,cov2);
         oo = pr(3) * u(A,m3,cov3);
         ss = mm + nn + oo;
         lsum = lsum + log(ss);
    end
end
plot(counter,lsum,'*')
hold on
counter = counter + 1
end
%%For displaying the final segmented output
figure(2);
image(C)
         
        
