function sum = lagrange(x, y, a)
 
 sum = 0;
 for i = 1:length(x)
     u = 1;
     l = 1;
     for j = 1:length(x)
         if j ~= i
             u = u * (a - x(j));
             l = l * (x(i) - x(j));
         end
     end
     sum= sum + u / l * y(i);
end
sum = idivide(sum,int16(1),'round');

