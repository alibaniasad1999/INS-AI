for i = 1:11
    variableName = ['l_', num2str(i)]; % Create the variable name
    eval([variableName, ' = net.Layers(i);']); % Assign the layer to the variable
end
