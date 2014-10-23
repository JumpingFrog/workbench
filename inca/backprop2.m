function [newW, newV, E] = backprop2(X,W,V,D,eta,epochs)
% [newW, newV, E] = backprop2(X,W,V,D,eta,epochs)
%   X is n x N, where each column is a data point.
%   W is h x (n+1), giving the weights to the hidden units and their biases.
%   V is m x (h+1), giving the weights and biases to output nodes
%   D is m x N, giving the desired ouput values for each sample.
%   eta is the learning rate.
%   epochs is the number of weight updates.
%
%   newW and newV are the network weights after learning.
%   E is a vector of mean error values, one for each epoch.

% from the data, find the number of datapoints (N) and the number of input
% values for each datapoint (h)
N = size(X,2); h = size(W,1);

% add a row of 1s to the data as the bias inputs
Xp = [ ones(1,N); X];

% the vector E is going to record the error after each epoch (pass through
% the training data.)
E = zeros(N, epochs);

for j=1:epochs
    for i=1:N
        % forward pass10
        % do weighted sum
        % n.b. weights are row vectors.
        Z = W * Xp(:, i);
        Z = arrayfun(@sigmoid, Z);
        Zp = [1; Z];
          % outputs from hidden nodes
        % Zp  =   % ...include bias
        Y   = V * Zp;   % outputs from output nodes
        Y = arrayfun(@sigmoid, Y);
        % accumulate total error for epoch j, for plotting
        E(j) = E(j) + sum(sum(Y-D(:,i)).^2/(2 * N)); 
        %error ber point
        e = D(:, i) - Y;
        % backward pass
        %Local grad at outputs f'(v) = y(1-y)
        Ylg = e.*(Y.*(1 - Y))
 
        % local gradient at hidden nodes
        Zlg =  Ylg(Z.*(1 - Z))
        %V   =   % calculate weight change at output layer
        %W XS  =   % calculate weight change at hidden layer
    end
end
newW = W; newV = V;
    

