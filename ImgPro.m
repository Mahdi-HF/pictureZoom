clc;
prompt = 'What is your image file neme ?  ';
imageName = input(prompt,'s');
Img = imread(imageName);

prompt2 = 'How much do you want to zoom in ?  ';
level = input(prompt2);

r = Img(:,:,1);
g = Img(:,:,2);
b = Img(:,:,3);

zoomedR = double(zeros(level*size(r,1), level*size(r,2)));
zoomedG = double(zeros(level*size(g,1), level*size(g,2)));
zoomedB = double(zeros(level*size(b,1), level*size(b,2)));

for i = 1:size(r,1)
    for j = 1:size(r,2)
        zoomedR((level*i)-(level-1), (level*j)-(level-1))= r(i,j);
        zoomedG((level*i)-(level-1), (level*j)-(level-1))= g(i,j);
        zoomedB((level*i)-(level-1), (level*j)-(level-1))= b(i,j);
    end
end

m =size(r,1)-1;
mm = size(r,2)-1;

for i = 1:m
    ii = level.*i-(level-1);
    for j = 1:mm
        jj = level.*j;
        for k=1:level-1
            zoomedR( ii , jj-level+k+1) = lagrange( [ jj-level+1, jj+1 ] , [ zoomedR( ii, jj-level+1) , zoomedR(ii, jj+1)] , jj-level+k+1);
            zoomedG( ii , jj-level+k+1) = lagrange( [ jj-level+1, jj+1 ] , [ zoomedG( ii, jj-level+1) , zoomedG(ii, jj+1)] , jj-level+k+1);
            zoomedB( ii , jj-level+k+1) = lagrange( [ jj-level+1, jj+1 ] , [ zoomedB( ii, jj-level+1) , zoomedB(ii, jj+1)] , jj-level+k+1);
        end
    end
end


for i = 1:m
    ii = level.*i;
    for j = 1:mm
        jj = level.*j;
        for k=1:level-1
            zoomedR( ii-level+k+1 , jj-level+1 ) = lagrange( [ ii-level+1, ii+1 ] , [ zoomedR( ii-level+1, jj-level+1) , zoomedR(ii+1, jj-level+1)] , ii+k);
            zoomedG( ii-level+k+1 , jj-level+1 ) = lagrange( [ ii-level+1, ii+1 ] , [ zoomedG( ii-level+1, jj-level+1) , zoomedG(ii+1, jj-level+1)] , ii+k);
            zoomedB( ii-level+k+1 , jj-level+1 ) = lagrange( [ ii-level+1, ii+1 ] , [ zoomedB( ii-level+1, jj-level+1) , zoomedB(ii+1, jj-level+1)] , ii+k);
        end
    end
end


for i = 1:m
    ii = level.*i;
    for j = 1:mm
        jj = level.*j;
        for p=1:level-1
            for k=1:level-1
                first = lagrange( [ ii-level+1, ii+1 ], [ zoomedR( ii-level+1, jj-level+p+1), zoomedR(ii+1, jj-level+p+1)] , ii+k);
                second = lagrange( [ jj-level+1, jj+1 ], [ zoomedR( ii-level+1, jj-level+1+p), zoomedR(ii+1, jj+1+p)] , jj+k);
                res = (first ./ 2 + second ./ 2);
                zoomedR( ii-level+k+1, jj-level+p+1 ) = res;

                first2 = lagrange( [ ii-level+1, ii+1 ], [ zoomedG( ii-level+1, jj-level+p+1), zoomedG(ii+1, jj-level+p+1)] , ii+k);
                second2 = lagrange( [ jj-level+1, jj+1 ], [ zoomedG( ii-level+1, jj-level+1+p), zoomedG(ii+1, jj+1+p)] , jj+k);
                res2 = (first2 ./ 2 + second2 ./ 2);
                zoomedG( ii-level+k+1, jj-level+p+1 ) = res2;

                first3 = lagrange( [ ii-level+1, ii+1 ], [ zoomedB( ii-level+1, jj-level+p+1), zoomedB(ii+1, jj-level+p+1)] , ii+k);
                second3 = lagrange( [ jj-level+1, jj+1 ], [ zoomedB( ii-level+1, jj-level+1+p), zoomedB(ii+1, jj+1+p)] , jj+k);
                res3 = (first3 ./ 2 + second3 ./ 2);
                zoomedB( ii-level+k+1, jj-level+p+1 ) = res3;
            end
        end
    end
end


s = level*size(r,1);
t = level*size(r,2);
zoomedpic = uint8(zeros(s, t, 3) );

for i = 1:s
    for j = 1:t
        zoomedpic(i,j,1) = uint8(zoomedR(i,j));
        zoomedpic(i,j,2) = uint8(zoomedG(i,j));
        zoomedpic(i,j,3) = uint8(zoomedB(i,j));
    end
end

subplot(1,2,1);imshow(Img); title('Before');
subplot(1,2,2);imshow(zoomedpic); title('after');

Folder = '/Users/mahdi/Documents/MATLAB';
File   = 'output.jpg';
Img    = zoomedpic;
imwrite(Img, fullfile(Folder, File));

disp("- - - - - - - - - - - - - - - - - - - - - - - - -");
disp("*** your picture is ready ***");
