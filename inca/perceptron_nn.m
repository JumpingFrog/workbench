% New perceptron
net = perceptron;

w = net.iw{1,1};
b = net.b{1};

d = data2d(1:2, :);
c = data2d(3, :);
for i = 1:size(c, 2)
    if c(i) == -1;
        %c(i) = 0;
    end
end

%net = train(net, d, c);

%w = net.iw{1,1}
%b = net.b{1}

w = myperceptron(d, c, 200);

b = w(1)
w= w(2:3)

px = [-1,2];

grad = -1*w(1)/w(2)

py = grad*px
py = py-b

a = net(d);
c = logical(c.');
d = d.';
classT = d(c, :);
classF = d(~c, :);
plot(classT(:, 1), classT(:,2), 'ob', classF(:, 1), classF(:,2), 'or', px, py, '-g')