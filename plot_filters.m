function [ output_args ] = plot_filters( filters )

npsi_filters = size(filters.psi.filter, 2);
hold on;
for i = 1:npsi_filters;
    plot_filter(filters.psi.filter{i});
end
plot_filter(filters.phi.filter);
hold off;
end

function plot_filter( filter ) 
    start = filter.start;
    len = size(filter.coefft,1);
    plot(start : start + len - 1, filter.coefft)
end

