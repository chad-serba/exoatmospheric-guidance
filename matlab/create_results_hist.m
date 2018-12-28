function create_results_hist( results, target, folder, prefix )
%CREATE_RESULTS_HIST Summary of this function goes here
%   Detailed explanation goes here

    targetParams = fields(target);
    targetParams{end+1} = 'nuAtInjection';
    targetParams{end+1} = 'burnDuration';
    numParams = numel(targetParams);
    
    if exist([folder, '/', prefix, '.ps'], 'file')
        delete([folder, '/', prefix, '.ps']);
    end
    
    if exist([folder, '/', prefix, '.pdf'], 'file')
        delete([folder, '/', prefix, '.pdf']);
    end
    
    nbin = 25;
    
    for jj = 1:numParams
       
        % find the error in this parameter
        if ~strcmp(targetParams{jj}, 'nuAtInjection') && ~strcmp(targetParams{jj}, 'e') && ~strcmp(targetParams{jj}, 'burnDuration')
            for ii = 1:length(results)
                param_res(ii) = results{ii}.endingOE.(targetParams{jj});
            end
            error = target.(targetParams{jj}) - param_res;
        elseif strcmp(targetParams{jj}, 'e')
            for ii = 1:length(results)
                param_res(ii) = norm(results{ii}.endingOE.(targetParams{jj}));
            end
            error = target.(targetParams{jj}) - param_res;
        else
            for ii = 1:length(results)
                param_res(ii) = results{ii}.(targetParams{jj});
            end
            error = param_res;
        end
        
        % what are the units on this parameter? 
        if strcmp(targetParams{jj}, 'nuAtInjection') || strcmp(targetParams{jj}, 'w') || strcmp(targetParams{jj}, 'i')
            unitStr = 'deg';
        elseif strcmp(targetParams{jj}, 'a')
            unitStr = 'km';
            error = error / 1000; % convert from meters to km
        elseif strcmp(targetParams{jj}, 'e')
            unitStr = 'n.d.';
        elseif strcmp(targetParams{jj}, 'burnDuration')
            unitStr = 'sec';
        else
            error('unknown parameter: %s', targetParams{jj})
        end
        
        % pull out statistics on the results
        sigma = std(error);
        mean_ = mean(error);
        max_ = max(error);
        min_ = min(error);
        
        figure
        hold on
        fith = histfit(error(2:end), nbin);
        ax = axis;
        nomh = plot([error(1) error(1)], ax(3:4), '-k', 'LineWidth', 1.25);
        meanh = plot([mean_ mean_], ax(3:4), '--k', 'LineWidth', 1.25);
        sigh = plot([mean_+3*sigma mean_+3*sigma], ax(3:4), '-.k', 'LineWidth', 1.25);
        sigh = plot([mean_-3*sigma mean_-3*sigma], ax(3:4), '-.k', 'LineWidth', 1.25);
        maxh = plot([max_ max_], ax(3:4), ':k', 'LineWidth', 1.25);
        minh = plot([min_ min_], ax(3:4), ':k', 'LineWidth', 1.25);
        grid on
        ylabel('Count')
        if ~strcmp(targetParams{jj}, 'burnDuration') && ~strcmp(targetParams{jj}, 'nuAtInjection')
            xlabel(sprintf('Error in %s (%s)', targetParams{jj}, unitStr))
        else
            xlabel(sprintf('%s (%s)', targetParams{jj}, unitStr))
        end
        legend([fith(2) nomh, meanh, sigh maxh], 'Normal Fit', 'Nominal', 'Mean', 'Mean\pm3\sigma', 'Max / Min')
        print([folder, '/', prefix], '-dpsc', '-append')
    end
end

