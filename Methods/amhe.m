clear;
clc;

PicOri=imread('home.jpg');
if isgray(PicOri)==0		%�ж�һ��ͼ���Ƿ�Ϊ�Ҷ�ͼ��
	PicGray=rgb2gray(PicOri);
else
	PicGray=PicOri;
end
figure(1),imshow(PicGray),title('ԭ�Ҷ�ͼ��');

h=imhist(PicGray);
figure(2),bar(0:255,imhist(PicGray),'k'),title('ԭͼ��ֱ��ͼ');

[m,n]=size(PicGray);
PicHEt=zeros(m,n);
N=m*n;
L=256;
%a=0.7

Xm=averpixcal(h,1,256);
Xml=averpixcal(h,1,Xm);
Xmu=averpixcal(h,Xm+1,256);

a=zeros(1,256);
for i=1:Xm+1
	a(i)=(Xm-Xml)/(Xmu-Xml);
end
for i=Xm+2:256
	a(i)=(Xmu-Xm)/(Xmu-Xml);
end

hpdf=h/N;

pmax=max(hpdf);
pmin=min(hpdf);
pmid=0.5*(pmin+pmax);

for i=1:256
	if hpdf(i)>pmid
		pamhe(i)=pmid+a(i)*((hpdf(i)-pmid)^2)/(pmax-pmid);
		%pamhe(i)=pmid+a*((hpdf(i)-pmid)^2)/(pmax-pmid);
	else
		pamhe(i)=pmid-a(i)*((pmid-hpdf(i))^2)/(pmid-pmin);
		%pamhe(i)=pmid-a*((pmid-hpdf(i))^2)/(pmid-pmin);
	end
end

camhet(1)=pamhe(1);
for i=2:256
	camhet(i)=pamhe(i)+camhet(i-1);
end

camhe=zeros(1,256);
camhe=camhet/camhet(L);

FuncHE=(L-1)*camhe;

for i=1:m
	for j=1:n
		PicHEt(i,j)=floor(FuncHE(PicGray(i,j)+1))-1;
	end
end

PicHE=uint8(PicHEt);
ht=imhist(PicHE);
Xmt=averpixcal(ht,1,256);
figure(3),imshow(PicHE),title('������ͼ��');
figure(4),bar(0:255,imhist(PicHE),'k'),title('�����ͼ��ֱ��ͼ');