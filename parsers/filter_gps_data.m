function [ run1_enu_filtered_151, run1_enu_filtered_201, run1_enu_filtered_251 ] = filter_gps_data( input_data, kalman_filter, median_filter_gps, median_filter_enu)
%FILTER_GPS_DATA Use either KF, median filtering over gps coordinates or
%over navsat/enu data
    warning('off', 'all');
    
    % KALMAN FILTER
    if kalman_filter
        gps_data = input_data(:,2:3);

        % construct a struct 
        clear s;
        s.x = nan;
        s.P = nan;
        s.H = eye(size(gps_data,2));
%         s.R = cov(gps_data);
        s.R = eye(size(gps_data,2), size(gps_data,2));
%         s.R = [1e-7, 0, 0;0 2e-6, 0; 0, 0 0.1]; % cov of measurement
        s.B = 0;
        s.u = 0;
        s.Q = 0;
        s.A = eye(size(gps_data,2));

        for t=1:size(gps_data,1)
            s(end).z = gps_data(t,:)';
            s(end+1) = kalmanfilter(s(end));
        end

        pose_struct_combined = zeros(1,size(gps_data,2));
        for i=2:size(s,2)
            pose_struct_combined = [pose_struct_combined;s(i).x(1:size(gps_data,2))'];
        end

        final_pose = pose_struct_combined(2:end,:);

        figure;
        geoshow(final_pose(:,1), final_pose(:,2));
    end
    
    % MEDIAN FILTER
    if median_filter_gps
        % ground truth GPS
        figure;
        hold on;
        
        subplot(2,3,1);
        gg = geoshow(input_data(:,2), input_data(:,3), 'Color', 'm');
        plot_google_map;
        title('Original GPS reading');
        xlabel('Longitude');
        ylabel('Latitude');
        
        
        % 150 order median filter (-75;+74)
        n = 151;
        run1_gps_filtered_150 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        subplot(2,3,2);
        gm150 = geoshow(run1_gps_filtered_150(2:end,2), run1_gps_filtered_150(2:end,3), 'DisplayType', 'line', 'Color', 'g');
        plot_google_map;
        title('Median Filtering of GPS with 150');
        xlabel('Longitude');
        ylabel('Latitude');
        
        % 200 order median filter (-100;+99)
        n = 201;
        run1_gps_filtered_200 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        subplot(2,3,3);
        gm200 = geoshow(run1_gps_filtered_200(2:end,2), run1_gps_filtered_200(2:end,3), 'DisplayType', 'line', 'Color', 'r');
        plot_google_map;
        title('Median Filtering of GPS with 200');
        xlabel('Longitude');
        ylabel('Latitude');
        
        % 250 order median filter (-125;+124)
        n = 251;        
        run1_gps_filtered_250 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        subplot(2,3,4);
        gm250 = geoshow(run1_gps_filtered_250(2:end,2), run1_gps_filtered_250(2:end,3), 'DisplayType', 'line', 'Color', 'b');
        plot_google_map;
        title('Median Filtering of GPS with 250');
        xlabel('Longitude');
        ylabel('Latitude');
        
        % 500 order median filter (-250;+249)
        n = 501;
        run1_gps_filtered_500 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        subplot(2,3,5);
        gm500 = geoshow(run1_gps_filtered_500(2:end,2), run1_gps_filtered_500(2:end,3), 'DisplayType', 'line', 'Color', 'k');
        plot_google_map;
        title('Median Filtering of GPS with 500');
        xlabel('Longitude');
        ylabel('Latitude');

        % all in one figure
        subplot(2,3,6);
        gg = geoshow(input_data(:,2), input_data(:,3), 'Color', 'm');
        gm150 = geoshow(run1_gps_filtered_150(2:end,2), run1_gps_filtered_150(2:end,3), 'DisplayType', 'line', 'Color', 'g');
        gm200 = geoshow(run1_gps_filtered_200(2:end,2), run1_gps_filtered_200(2:end,3), 'DisplayType', 'line', 'Color', 'r');
        gm250 = geoshow(run1_gps_filtered_250(2:end,2), run1_gps_filtered_250(2:end,3), 'DisplayType', 'line', 'Color', 'b');
        gm500 = geoshow(run1_gps_filtered_500(2:end,2), run1_gps_filtered_500(2:end,3), 'DisplayType', 'line', 'Color', 'k');

        title('Median Filtering comparison');
        xlabel('Longitude');
        ylabel('Latitude');
%         view(180, 0);
        legend([gg, gm150 gm200 gm250 gm500], 'GPS', 'Median 150', 'Median 200', 'Median 250', 'Median 500', 0);
        hold off;
    end
    
    % MEDIAN FILTER WITH ENU DATA
    if median_filter_enu
        figure;
        hold on;
        
        % show original data
        gg = scatter3(input_data(:,1), input_data(:,2), input_data(:,3));
        % n-th order median filtetr
        n = 151;
        run1_enu_filtered_151 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        gm151 = scatter3(run1_enu_filtered_151(:,1), run1_enu_filtered_151(:,2), run1_enu_filtered_151(:,3));
        
        n = 201;
        run1_enu_filtered_201 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        gm201 = scatter3(run1_enu_filtered_201(:,1), run1_enu_filtered_201(:,2), run1_enu_filtered_201(:,3));
        
        n = 251;
        run1_enu_filtered_251 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        gm251 = scatter3(run1_enu_filtered_251(:,1), run1_enu_filtered_251(:,2), run1_enu_filtered_251(:,3));
        
        n = 501;
        run1_enu_filtered_501 = [input_data(:,1), medfilt1(input_data(:,2), n), medfilt1(input_data(:,3), n), medfilt1(input_data(:,4), n)];
        gm501 = scatter3(run1_enu_filtered_501(:,1), run1_enu_filtered_501(:,2), run1_enu_filtered_501(:,3));
        
        % plotting time
        title('Median Filtering comparison');
        xlabel('Relative Altitude');
        ylabel('Relative Longitude');
        zlabel('Relative Latitude');
        view(90, 0);
        legend([gg, gm151 gm201 gm251 gm501], 'GPS', 'Median 151', 'Median 201', 'Median 251', 'Median 501', 0);
        hold off;
    end
    
    
end

