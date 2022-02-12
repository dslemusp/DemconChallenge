function printGeneration(aGeneration)
    str = "";
    for i = 1:length(aGeneration)
        if aGeneration(i) == 1
            str = strcat(str, "*");
        else
            str = strcat(str, " ");
        end
    end
    disp(str);
end