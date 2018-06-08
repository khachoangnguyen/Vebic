function save_all_figures(fig_name,dir_name,n)
datetime = datestr(date);
datetime = strrep(datetime,'-','_');
figlist=findobj('type','figure'); %find all available figures
for i = 1:numel(figlist)
    saveas(figlist(i),fullfile(dir_name,[fig_name '_' num2str(n) '.' num2str(i) '_' datetime '.png']));
end
end