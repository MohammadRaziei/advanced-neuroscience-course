function save_figure(fig,fileName)
    frame = getframe(fig);
    imwrite(frame.cdata,fileName);
end