function x = demax(in)
    x = in./max(abs(in(:)));
end