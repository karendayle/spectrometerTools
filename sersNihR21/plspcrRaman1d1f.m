%% Partial Least Squares Regression and Principal Components Regression
% kdk: search for CHOOSE to see setpoints you can change

% This program applies Partial Least Squares Regression (PLSR) and
% Principal Components Regression (PCR) to a set of Raman spectra
% of a set of concentrations of an analyte, and discusses the effectiveness
% of the two methods.  
%
% PLSR and PCR are both methods to model a response variable when there are
% a large number of predictor variables, and those predictors are highly 
% correlated or even collinear.  Both methods construct new predictor 
% variables, known as components, as linear combinations of the original 
% predictor variables, but they construct those components in different
% ways:
%
% 1) PCR creates components to explain the observed variability in the 
% predictor variables, without considering the response variable at all. 
%
% 2) On the other hand, PLSR takes the response variable into account, and
% therefore often leads to models that are able to fit the response 
% variable with fewer components.  Whether or not that ultimately 
% translates into a more parsimonious model, in terms of its practical use,
% depends on the context.
%
%   Based on material from Copyright 2008 The MathWorks, Inc.

%   Dayle Kotturi 10/26/2020
%   Change list:
%   Modify to input Raman spectra to determine concentration from intensity
%   Add figure command to avoid overwrite
%   Read in the averaged Raman spectra from various dirs
%   Add plot color by pH
%   Adapt for multianalytes, and multiple batches of each
%   Change pH to be generic concentration of any of the 10 analytes.
%   Use "blank" to indicate analyte conc = 0.
%   Make the choice of how many components to use data driven by extracting
%   out the number for a specific level of explained variance, error
%   Add figures of every step and save them as both .fig and .png
%   Add boolean called fullAnalysis to skip past 3d plotting for speed

%   TO DO: 
%   Add option to use 1, 2 or 3 batches of an analyte to make the model
%   Also, why does using blanks cause the scale to be off? Aren't I
%   normalizing them all? Fixed, this was because blanks were not getting
%   baseline corrected prior to going into the array
%   What I'm still missing is that the analyte spectra 1-5 are actually 
%   different conc'ns of analyte, i.e. they are not simply repeats.

% Newly required following 2021/03/01 script reorg
addpath('../functionLibrary');

global myOption
% CHOOSE myOption
%myOption = 1; %SPIE
%myOption = 2; % NIH R21 1.1
myOption = 3; % NIH R21 1.1f

global analyteStart
global analyteEnd
% CHOOSE analytes to use
global batchStart
global batchEnd
switch myOption
    case 1 % pH
        analyteStart = 1;
        analyteEnd = 1;
    case 2 % CHOOSE from 2 to 10 (get names from "analyteNames" fn
        analyteStart  = 2;
        analyteEnd = 10;
        batchStart = 1;
        batchEnd = 6;  % a.k.a. A to F
    case 3 % pH
        analyteStart = 1; 
        analyteEnd = 1; % pH only
        batchStart = 1; 
        batchEnd = 6; % pH levels
end

global useBlanks
% CHOOSE: set useBlanks to 1 if you want the spectra of AuNPs alone used in
% the analysis; set useBlanks to 0 if you want to exclude it.
useBlanks = 1;

global PCRthreshold
% CHOOSE the accuracy that you want
PCRthreshold = 0.99;
global PLSthreshold
% CHOOSE the accuracy that you want
PLSthreshold = 99;

global fullAnalysis
%CHOOSE 0 to just draw all the 3d plots, CHOOSE 1 to run the analysis
fullAnalysis = 1;

% Colors:
global black
global purple
global blue
global ciel
global green
global rust
global gold
global red
global cherry
global magenta
global colors

% RGB
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
magenta = [1.0, 0.0, 1.0];
colors = [black; magenta; red; gold; green; ciel; blue; purple];

global firstTime
firstTime = 1;

global batchNames
batchNames = ['A'; 'B'; 'C'; 'D'; 'E'; 'F'];
global pHNames
pHNames = ["4.0"; "5.0"; "5.5"; "6.0"; "6.5"; "7.0"];
global conc
global waveNumbers
global rsquaredPCRTable
global rsquaredPLSTable
rsquaredPCRTable = [];
rsquaredPLSTable = [];
global myPCR
global myPLS
myPLS = [];
myPCR = [];

global figureNumber
figureNumber = 0;
%% kdk: Clear previous plots

close all

%% Load the Data and Do the Analysis

% kdk 2020/10/26, Change to input Raman spectra
% First, for myOption = 1 case:
% - load set of N Raman spectra, each 1024 values long - done
% - use the averaged spectra (with dark removed, baseline
% - corrected) - done
% - normalize too - done
% - normalize again by max - done
% - store the array of 1024 wavenumbers once - done 
% - replace octane with pH level (known) as a float (so sorting is poss) - done
% - figure out why each pH level shows only 1 avg, not 5 - 
% - in the regression and PLS plots, color by original pH
% kdk 2020/11/1: adapt for NIH Direct Sensing Expt 1.1 dataset

switch myOption
    case 1
        % Load the SPIE data
        [waveNumbers, spectra, analyteArr] = getSPIERamanSpectra();
        % Do the analysis
        analysis(waveNumbers, spectra, analyteArr, 1, 1);
    case 2
        % Load the NIH data
        blackPlates = getNIHRamanSpectraBlackPlates();
        blackPlatesAndWater = getNIHRamanSpectraBlackPlatesAndWater();  
        blanksAllBatches = getNIHRamanSpectraBlanks(); % read blanks for each batch
        % 2020/12/5 TO DO: pass in blanks for batchChoice
        for analyteChoice = analyteStart:analyteEnd
            % 2020/12/5 TO DO: I want to use multiple batches in the model
            % Load the data
            [spectra, analyteArr] = getNIHRamanSpectra(analyteChoice, ...
                batchStart, batchEnd);

            % Process a single analyte
            processSpectra(blackPlates, blackPlatesAndWater, blanksAllBatches, ...
                spectra, analyteArr, analyteChoice, batchStart, batchEnd);
        end

        if fullAnalysis == 1
            % kdk: Add tabulation of correlation values for PCR and PLS
            % kdk: Add numbers of components for the desired explained var (PLS)
            % and % coverage by the PCR
            for analyteChoice = analyteStart:analyteEnd
                fprintf('analyte: %s batches: %s, %s, %s\n', analyteNames(analyteChoice), ...
                    batchNames(1), batchNames(2), batchNames(3));
                fprintf('PLS rsquared using %d PCs ', myPLS(analyteChoice));
    %             for batchChoice = batchStart:batchEnd
                    fprintf('%f ', rsquaredPLSTable(analyteChoice));
    %             end
                fprintf('\n');
                fprintf('PCR rsquared using %d PCs ', myPCR(analyteChoice));
    %             for batchChoice = batchStart:batchEnd
                    fprintf('%f ', rsquaredPCRTable(analyteChoice));
    %            end
                fprintf('\n');
            end
        end
     case 3
        blackPlates = [];
        blackPlatesAndWater = [];
        blanksAllBatches = [];
        for analyteChoice = analyteStart:analyteEnd
            % 2020/12/5 TO DO: I want to use multiple batches in the model
            % Load the data
            [spectra, analyteArr] = getNIHRamanSpectra(analyteChoice);

            % Process a single analyte
            processSpectra(blackPlates, blackPlatesAndWater, blanksAllBatches, ...
                spectra, analyteArr, analyteChoice);
        end
end
% end of main

function c = processSpectra(blackPlates, blackPlatesAndWater, blanksAllBatches, ...
    ramanSpectra, analyte, analyteChoice)
    global myPCR
    global myPLS
    global batchNames
    global rsquaredPCRTable
    global rsquaredPLSTable
    global conc
    global PCRthreshold
    global PLSthreshold
    global firstTime
    global useBlanks
    global fullAnalysis
    global myOption
    global waveNumbers
    global colors
    global batchStart
    global batchEnd
    global pHNames
    
    if myOption == 2 && firstTime == 1 % this is only relevant for NIH data
        % plot the blanks for all batches
        figure % figure 1
        [nrows, ~] = size(waveNumbers);
        for i = 1:6 
            plot(waveNumbers(1:nrows),blanksAllBatches(i,:)');
            hold on
        end
        xlabel('Wavenumber (cm^-^1)'); 
        myYLabel = sprintf('Intensity (A.U.)');
        ylabel(myYLabel); axis('tight');
        grid on
        myTitle = sprintf('Baseline corrected blanks for all batches of 10nM AuNPs');
        title(myTitle);
        hleg = legend({'A' 'B' 'C' 'D' 'E' 'F'}, 'location','NE');
        htitle = get(hleg,'Title');
        set(htitle,'String','Batch');
        saveMyPlot(0, gcf, myTitle, 'all blanks');
        
        figure % figure 2
        for i = 1:3
            plot(waveNumbers(1:nrows)',blackPlates(i,:)');
            hold on
        end
        xlabel('Wavenumber (cm^-^1)'); 
        myYLabel = sprintf('Intensity (A.U.)');
        ylabel(myYLabel); axis('tight');
        grid on
        myTitle = sprintf('Baseline corrected black plate');
        title(myTitle);
        hleg = legend({'1' '2' '3'}, 'location','NE');
        htitle = get(hleg,'Title');
        set(htitle,'String','Spectrum');
        saveMyPlot(0, gcf, myTitle, 'all black plates');
        
        figure % figure 3
        plot(waveNumbers(1:nrows),blackPlatesAndWater(1,:)');
        hold on
        xlabel('Wavenumber (cm^-^1)'); 
        myYLabel = sprintf('Intensity (A.U.)');
        ylabel(myYLabel); axis('tight');
        grid on
        myTitle = sprintf('Baseline corrected water and black plate');
        title(myTitle);
        saveMyPlot(0, gcf, myTitle, 'water and black plate');
        
        firstTime = 0;
    end
    
    % kdk: use same approach for both SPIE and NIH datasets
    [Nspectra, Npoints] = size(ramanSpectra);
    oldorder = get(gcf,'DefaultAxesColorOrder');
    
    %% kdk: just the 10 nM conc of NPs now
    % and spread out the concs of analytes, instead of plotting them
    % at the same y value
    if myOption == 2    
        figure
        x1 = repmat(waveNumbers(1:Npoints)',6,1)';
        y1 = repmat((0:5)',1,Npoints)'; % use LUT to get actual analyte conc
        for i = batchStart:batchEnd
            
            % set up the offset to batch i, allowing for 6 concentrations
            first = (i-1)*5 + 1;
            last = first + 5;
            
            z1 = ramanSpectra(first:last,:)'; 
            plot3(x1, y1, z1, 'Color', colors(i,:));
            pause(1);
            hold on;
        end
        set(gcf,'DefaultAxesColorOrder',oldorder);
        xlabel('Wavenumber (cm^-^1)'); 
        ylabel('concentration of analyte'); axis('tight'); % kdk TO DO what is 'tight'?
        zlabel('Intensity (A.U.)');
        grid on

        myTitle = sprintf('%s all batches with blank for 10nM AuNPs', ...
            analyteNames(analyteChoice));

        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, 'all spectra at 10 nM AuNPs 3D');
    end
    
    if myOption == 3    % 2021/03/02 NEW
        figure
        x1 = repmat(waveNumbers(1:Npoints)',6,1)';
        y1 = repmat((0:5)',1,Npoints)'; % use LUT to get actual analyte conc
        for i = batchStart:batchEnd
            
            % set up the offset to batch i, allowing for 6 concentrations
            first = (i-1)*5 + 1;
            last = first + 5;
            
            z1 = ramanSpectra(first:last,:)'; 
            plot3(x1, y1, z1, 'Color', colors(i,:));
            pause(1);
            hold on;
        end
        set(gcf,'DefaultAxesColorOrder',oldorder);
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Wavenumber (cm^-^1)'); 
        ylabel('concentration of analyte'); axis('tight'); % kdk TO DO what is 'tight'?
        zlabel('Intensity (A.U.)');
        grid on
        myTitle = sprintf('%s all batches for 10nM AuNPs', ...
            analyteNames(analyteChoice));
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, 'all spectra at 10 nM AuNPs 3D');
    end
    
    %% kdk: Draw the sets of spectra at each conc'n on their own plot
    iiStart = 1;
    if useBlanks == 1
        iiEnd = iiStart + 5;
    else
        iiEnd = iiStart + 4;
    end

    if myOption == 2
        % plot each batch alone
        for i = batchStart:batchEnd
            figure
            set(gca,'FontSize',20,'FontWeight','bold','box','off');
            myColor = 3; % choose a different color set than the 3D plots
                         % b/c those colors represent batches and here,
                         % the analyte conc'ns are being distinguished
            % set up the offset to batch i, allowing for 6 concentrations
            first = (i-1)*6 + 1; % 6 is for the six concentrations of
                                 % this batch. Use 5 if blanks not used
            last = first + 5;
            for j = first:last
                plot(waveNumbers(1:Npoints)',ramanSpectra(j,:)', 'Color', colors(myColor,:));
                hold on;
                pause(1);

                % Print for debugging to check what is being accessed
                fprintf('%s:%s index %d color %d\n', analyteNames(analyteChoice), ...
                    batchNames(i), j, myColor);
                
                % for next time
                myColor = myColor + 1;
            end

%                 set(gcf,'DefaultAxesColorOrder',oldorder); rm 2020/12/10
            xlabel('Wavenumber (cm^-^1)'); 
            myYLabel = sprintf('Normalized Intensity at conc %.2f nM AuNPs', conc(1));
            ylabel(myYLabel); axis('tight');
            grid on

            myTitle = sprintf('%s batch %s with blank', ...
                analyteNames(analyteChoice), batchNames(i));

            title(myTitle);

            % kdk: save figure
            % ugh, if I use the label containing a '.', saveas interprets this
            % as file type delimiter, so change from using the actual conc
            % values to using 'D' for decimal point.
            myYLabel = 'conc 10nm AuNPs';
            saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);

            if useBlanks == 1
                iiStart = iiStart + 5;
                iiEnd = iiEnd + 5;
            else
                iiStart = iiStart + 4;
                iiEnd = iiEnd + 4;
            end
        end
    end
  
    if myOption == 3
        % plot each batch alone
        for i = batchStart:batchEnd
            figure
            myColor = 3; % choose a different color set than the 3D plots
                         % b/c those colors represent batches and here,
                         % the analyte conc'ns are being distinguished
            % set up the offset to batch i, allowing for 6 concentrations
            first = (i-1)*6 + 1; % 6 is for the six concentrations of
                                 % this batch. Use 5 if blanks not used
            last = first + 5;
            for j = first:last
                plot(waveNumbers(1:Npoints)',ramanSpectra(j,:)', 'Color', colors(myColor,:));
                hold on;
                pause(1);

                % Print for debugging to check what is being accessed
                fprintf('%s:%s index %d color %d\n', analyteNames(analyteChoice), ...
                    pHNames(i), j, myColor);
                
                % for next time
                myColor = myColor + 1;
            end

%                 set(gcf,'DefaultAxesColorOrder',oldorder); rm 2020/12/10
            set(gca,'FontSize',20,'FontWeight','bold','box','off');            
            xlabel('Wavenumber (cm^-^1)'); 
            myYLabel = sprintf('Normalized Intensity at conc %.2f nM AuNPs', conc(1));
            ylabel(myYLabel); axis('tight');
            grid on

            myTitle = sprintf('%s %s', ...
                analyteNames(analyteChoice), pHNames(i));

            title(myTitle);

            % kdk: save figure
            % ugh, if I use the label containing a '.', saveas interprets this
            % as file type delimiter, so change from using the actual conc
            % values to using 'D' for decimal point.
            myYLabel = 'conc 10nm AuNPs';
            saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);

            if useBlanks == 1
                iiStart = iiStart + 5;
                iiEnd = iiEnd + 5;
            else
                iiStart = iiStart + 4;
                iiEnd = iiEnd + 4;
            end
        end
    end    
    
    if fullAnalysis == 1
        %% Fitting the Data with Ten and then a data driven number of PLS Components
        % Use the |plsregress| function to fit a PLSR model with ten PLS components
        % and one response.
        X = ramanSpectra;
        y = analyte;
        [n,p] = size(X);
        % kdk: prior to choosing the optimal, take a look at up to 10 components
        % 2020/12/5 10 is too many now that y is 6 analyte concs. Limited to 5. 
        [Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(...
            X,y,10);
        %%
        % Ten components may be more than will be needed to adequately fit the
        % data, but diagnostics from this fit can be used to make a choice of a
        % simpler model with fewer components. For example, one quick way to choose
        % the number of components is to plot the percent of variance explained in
        % the response variable as a function of the number of components.
        figure % figure 6
        plot(1:10,cumsum(100*PLSPctVar(2,:)),'-bo');
        % kdk: save lowest number of components that explains > 90% of
        % variance, or any desired percentage
        minPLSComponents = 0;
        for i = 1:10
            xx = cumsum(100*PLSPctVar(2,1:i));
            if minPLSComponents == 0 && xx(i) > PLSthreshold
                minPLSComponents = i; % # components needed to explain 90%
            end
        end
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        fprintf('#PLS components explaining %f percent of variance = %d\n', ...
            PLSthreshold, minPLSComponents);
        xlabel('Number of PLS components');
        myYLabel = 'Percent Variance Explained in Y';
        ylabel(myYLabel);
        grid on
        switch myOption
            case 2
                myTitle = sprintf('%s all batches with blank for 10nM AuNPs', ...
                    analyteNames(analyteChoice));
            case 3
                myTitle = sprintf('%s all batches for 10nM AuNPs', ...
                    analyteNames(analyteChoice));
        end
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %%
        % Original: In practice, more care would probably be advisable in choosing the number
        % of components.  Cross-validation, for instance, is a widely-used method
        % that will be illustrated later in this example.  For now, the above plot
        % suggests that PLSR with two components explains most of the variance in
        % the observed |y|.  Compute the fitted response values for the
        % two-component model.
        %[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,2); 

        % kdk: change from 2 to use a number of components that explains
        % desired percentage of the variance
        [Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,minPLSComponents);
        yfitPLS = [ones(n,1) X]*betaPLS;

        %%
        % kdk: TO DO START HERE can I make a loop around this and draw figs for
        % range of PCs?

        % Original: Next, fit a PCR model with two principal components.
        % kdk: actually the model is fit without setting 2 PCs, this number
        % is selected after.

        % The first step is to perform Principal Components Analysis on |X|,
        % using the |pca| function, and retaining two principal components. 

        % PCR is then just a linear regression of the response variable on 
        % those two components.

        % It often makes sense to normalize each variable first by its standard
        % deviation when the variables have very different amounts of variability,
        % however, that is not done here. 
        % Modification by kdk: I normalized spectra prior (although did not
        % divide by std dev) 
        % kdk: PCAVar are the eigenvalues. They are used to assess expected var
        [PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
        %betaPCR = regress(y-mean(y), PCAScores(:,1:2));

        % kdk: NEW
        % kdk:replaced with optimal number of components
        % kdk: TO DO how do I get minPCRComponents by this point?
        % kdk: Answer is by summing PCAVar and calculating fraction that each
        % eigenvalue is and then choosing the number based on desired percent
        sumEigenValues = sum(PCAVar);
        fractionEigenValues = PCAVar/sumEigenValues;
        ii = 1;
        sumSoFar = 0;
        minPCRComponents = 0;
        % only look at 100 largest eigenvalues
        cumulativeEigenValues = zeros(1, 100, 'double');
        
        while PCAVar(ii) ~= 0 && minPCRComponents == 0 && ii < 101    
            cumulativeEigenValues(ii) = sum(fractionEigenValues(1:ii));
            if cumulativeEigenValues(ii) > PCRthreshold
                minPCRComponents = ii;
            end
            ii = ii + 1;
            if ii == 101
                fprintf('100 eigenvalues are insufficient to meet threshold');
            end
        end
        fprintf('#PCR components explaining %f percent of variance = %d\n', ...
            PCRthreshold*100., minPCRComponents);
        betaPCR = regress(y-mean(y), PCAScores(:,1:minPCRComponents)); 
        
        % New 2020/12/11 plot the 10 largest eigenvalues for the record
        figure
        plot(cumulativeEigenValues(1:ii-1));
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Eigenvalue index');
        myYLabel = 'Normalized Eigenvalue';
        ylabel(myYLabel);
        title(myTitle);
        grid on;
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        
        %%
        % To make the PCR results easier to interpret in terms of the original
        % spectral data, transform to regression coefficients for the original,
        % uncentered variables.
        %betaPCR = PCALoadings(:,1:2)*betaPCR;
        % kdk:replaced with optimal number of components
        betaPCR = PCALoadings(:,1:minPCRComponents)*betaPCR;
        betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
        yfitPCR = [ones(n,1) X]*betaPCR;

        %%
        % Plot fitted vs. observed response for the PLS and PCR fits.
        figure % figure 7
        for ii = 1:Nspectra
            % kdk TO DO: are these colors good for all analytes?
            plot(y(ii),yfitPLS(ii),'o','Color',pHColor(ii));
            hold on;
            plot(y(ii),yfitPCR(ii),'^','Color',pHColor(ii));
            hold on;
        end
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Observed Response');
        myYLabel = 'Fitted Response';
        ylabel(myYLabel);
        plsLegend = sprintf('PLSR with %d Components', minPLSComponents);
        pcrLegend = sprintf('PCR with %d Components', minPCRComponents);
        legend({plsLegend pcrLegend}, 'location','NW');
        grid on;
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);  
        myPLS(analyteChoice) = minPLSComponents; % 2020/12/5 now all batches
        myPCR(analyteChoice) = minPCRComponents;
        %%
        % Orginal: In a sense, the comparison in the plot above is not a fair one -- the
        % number of components (two) was chosen by looking at how well a
        % two-component PLSR model predicted the response, and there's no reason
        % why the PCR model should be restricted to that same number of components.
        % With the same number of components, however, PLSR does a much better job
        % at fitting |y|.  In fact, looking at the horizontal scatter of fitted
        % values in the plot above, PCR with two components is hardly better than
        % using a constant model.  The r-squared values from the two regressions
        % confirm that.
        % kdk: I am setting the # components based on the desired % explained
        TSS = sum((y-mean(y)).^2);
        RSS_PLS = sum((y-yfitPLS).^2);
        rsquaredPLS = 1 - RSS_PLS/TSS; % kdk TO DO: save this to an array for tabulating
        rsquaredPLSTable(analyteChoice) = rsquaredPLS;
        %%
        RSS_PCR = sum((y-yfitPCR).^2);
        rsquaredPCR = 1 - RSS_PCR/TSS; % kdk TO DO: save this to an array for tabulating
        rsquaredPCRTable(analyteChoice) = rsquaredPCR;
        %%
        % Another way to compare the predictive power of the two models is to plot the
        % response variable against the two predictors in both cases.
    % kdk 11/9/2020 remove excess plots
    %     figure % figure 8
    %     % plot3(Xscores(:,1),Xscores(:,2),y-mean(y),'bo'); % original, before color
    %     for ii = 1:Nspectra
    %         plot3(Xscores(ii,1),Xscores(ii,2),y-mean(y),'bo', 'Color', pHColor(ii));
    %         hold on;
    %     end
    %     legend('PLSR');
    %     xlabel('X 1 score'); % kdk
    %     ylabel('X 2 score'); % kdk
    %     zlabel('Response Variable');
    %     grid on; view(-30,30);
    %     title(myTitle);
    %     saveMyPlot(analyteChoice, gcf, myTitle, 'PLS Response');
        %%
        % It's a little hard to see without being able to interactively rotate the
        % figure, but the PLSR plot above shows points closely scattered about a plane.
        % On the other hand, the PCR plot below shows a cloud of points with little
        % indication of a linear relationship.
    % kdk 11/9/2020 remove excess plots
    %     figure % figure 9
    %     % plot3(PCAScores(:,1),PCAScores(:,2),y-mean(y),'r^'); % original, ...
    %     % before color
    %     for ii = 1:Nspectra
    %         plot3(PCAScores(ii,1),PCAScores(ii,2),y-mean(y),'r^', 'Color', ...
    %             pHColor(ii));
    %         hold on;
    %     end
    %     legend('PCR');
    %     xlabel('PCA 1 score'); % kdk
    %     ylabel('PCA 2 score'); % kdk
    %     zlabel('Response');
    %     grid on; view(-30,30);
    %     title(myTitle);
    %     saveMyPlot(analyteChoice, gcf, myTitle, 'PCA Response');
        %%
        % Notice that while the two PLS components are much better predictors of
        % the observed |y|, the following figure shows that they explain
        % somewhat less variance in the observed |X| than the first two principal
        % components used in the PCR.
    % kdk 11/9/2020 remove excess plots
    %     figure % figure 10
    %     plot(1:10,100*cumsum(PLSPctVar(1,:)),'b-o',1:10,  ...
    %         100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)),'r-^'); 
    %     % kdk TO DO do I care about the percent var in x?
    %     xlabel('Number of Principal Components');
    %     myYLabel = 'Percent Variance Explained in X';
    %     ylabel(myYLabel);
    %     legend({'PLSR' 'PCR'},'location','SE');
    %     title(myTitle);
    %     saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %%
        % The fact that the PCR curve is uniformly higher suggests why PCR with two
        % components does such a poor job, relative to PLSR, in fitting |y|.  PCR
        % constructs components to best explain |X|, and as a result, those first
        % two components ignore the information in the data that is important in
        % fitting the observed |y|.

        %% Fitting with More Components
        % Orginal: As more components are added in PCR, it will necessarily do a better job
        % of fitting the original data |y|, simply because at some point most of the
        % important predictive information in |X| will be present in the principal
        % components.  For example, the following figure shows that the
        % difference in residuals for the two methods is much less dramatic when
        % using ten components than it was for two components.
        % kdk: START HERE change this so that any number of components from 2 to 10 works
        yfitPLS10 = [ones(n,1) X]*betaPLS10;

        betaPCR10 = regress(y-mean(y), PCAScores(:,1:10));
        betaPCR10 = PCALoadings(:,1:10)*betaPCR10;
        betaPCR10 = [mean(y) - mean(X)*betaPCR10; betaPCR10];
        yfitPCR10 = [ones(n,1) X]*betaPCR10;

        figure % figure 11
%         plot(y,yfitPLS10,'bo',y,yfitPCR10,'r^'); 2020/12/10 match colors
          % to plot with optimized num of components
        for ii = 1:Nspectra
            plot(y(ii),yfitPLS10(ii),'o','Color',pHColor(ii));
            hold on;
            plot(y(ii),yfitPCR10(ii),'^','Color',pHColor(ii));
            hold on;
        end
        set(gca,'FontSize',20,'FontWeight','bold','box','off');

        xlabel('Observed Response');
        ylabel('Fitted Response');
        legend({'PLSR with 10 components' 'PCR with 10 Components'},  ...
            'location','NW');
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, 'PLSR and PCR response');
        %%
        % Both models fit |y| fairly accurately, although PLSR still makes a
        % slightly more accurate fit.  However, ten components is still an
        % arbitrarily-chosen number for either model.


        %% Choosing the Number of Components with Cross-Validation
        % It's often useful to choose the number of components to minimize the
        % expected error when predicting the response from future observations on
        % the predictor variables.  Simply using a large number of components will
        % do a good job in fitting the current observed data, but is a strategy
        % that leads to overfitting.  Fitting the current data too well results in
        % a model that does not generalize well to other data, and gives an
        % overly-optimistic estimate of the expected error.
        %
        % Cross-validation is a more statistically sound method for choosing the
        % number of components in either PLSR or PCR.  It avoids overfitting data
        % by not reusing the same data to both fit a model and to estimate
        % prediction error. Thus, the estimate of prediction error is not
        % optimistically biased downwards.
        %
        % |plsregress| has an option to estimate the mean squared prediction error
        % (MSEP) by cross-validation, in this case using 10-fold C-V.
        [Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X,y,10,'CV',10);
        % kdk second time calling plsregress, this time for the
        % cross-validation
        %%
        % For PCR, |crossval| combined with a simple function to compute the sum of
        % squared errors for PCR, can estimate the MSEP, again using 10-fold
        % cross-validation.
        PCRmsep = sum(crossval(@pcrsse,X,y,'KFold',10),1) / n;

        %%
        % Original: The MSEP curve for PLSR indicates that two or three components does about
        % as good a job as possible.  On the other hand, PCR needs four components
        % to get the same prediction accuracy.

        figure % figure 12
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        % plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^'); kdk: MJM catches badness of
        % claiming to use 0 components, but why are there 11 anyway?
        plot(1:11,PLSmsep(2,:),'b-o',1:11,PCRmsep,'r-^');
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Number of components');
        myYLabel = 'Estimated Mean Squared Prediction Error';
        ylabel(myYLabel);
        legend({'PLSR' 'PCR'},'location','NE');
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %%
        % In fact, the second component in PCR _increases_ the prediction error
        % of the model, suggesting that the combination of predictor variables
        % contained in that component is not strongly correlated with |y|.  Again,
        % that's because PCR constructs components to explain variation in |X|, not
        % |y|.


        %% Model Parsimony
        % So if PCR requires four components to get the same prediction accuracy as
        % PLSR with three components, is the PLSR model more parsimonious?  That
        % depends on what aspect of the model you consider.
        %
        % The PLS weights are the linear combinations of the original variables
        % that define the PLS components, i.e., they describe how strongly each
        % component in the PLSR depends on the original variables, and in what
        % direction.
        %[Xl,Yl,~,Ys,beta,pctVar,mse,stats] = plsregress(X,y,3);
        % kdk: Hmm, okay, but variance in X is not important for spectra
        % at fixed wavenumbers, right?
        % kdk: use minPLSComponents here instead of hardcoded value
        % NO 2021/3/12 minPLSComponents = 5; % 2020/11/13 - just to plot them all
        [Xl,Yl,~,Ys,beta,pctVar,mse,stats] = plsregress(X,y,minPLSComponents);
        figure % figure 13
        % plot(1:Npoints,stats.W,'-'); % original
        plot(waveNumbers(1:Npoints),stats.W,'-'); % kdk use wavenumbers
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Wavenumber (cm^-^1)');
        myYLabel = 'PLS Weight';
        ylabel(myYLabel);

        switch minPLSComponents
            case 1
                legend({'1st Component'}, 'location','NW');
            case 2
                legend({'1st Component' '2nd Component'}, 'location','NW');
            case 3
                legend({'1st Component' '2nd Component' '3rd Component'}, ...
                    'location','NW');
            case 4
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component'}, 'location','NW');
            case 5
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component'}, 'location','NW');
            case 6
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component'}, ...
                    'location','NW');
            case 7
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component'}, 'location','NW');
            case 8
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component'}, 'location','NW');
            case 9
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component' '9th Component'}, ....
                    'location','NW');
            case 10
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component' '9th Component' ...
                    '10th Component'}, 'location','NW');
            otherwise
                fprintf('unrecognized minPLSComponents %d\n', minPLSComponents);
        end
        xlim([min(waveNumbers) max(waveNumbers)]);
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);

    % kdk 11/9/2020 removed excess plots
    %     %% kdk NEW plot the residuals in X and Y, color by pH
    %     figure % figure 14
    %     for ii = 1:Nspectra
    %         plot(waveNumbers(1:Npoints),stats.Xresiduals(ii,:),'-','Color',pHColor(ii));
    %         hold on;
    %     end
    %     xlabel('Wavenumber (cm^-^1)');
    %     ylabel('PLS X residuals');
    %     grid on
    %     title(myTitle);
    %     
    %     figure % figure 15
    %     for ii = 1:Nspectra
    %         plot(analyte(ii),stats.Yresiduals(ii),'^','Color',pHColor(ii));
    %         hold on;
    %     end
    %     xlabel(analyteNames(analyteChoice));
    %     ylabel('PLS Y residuals');
    %     grid on
    %     title(myTitle);
    %     saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %%
        % Similarly, the PCA loadings describe how strongly each component in the PCR
        % depends on the original variables.
        figure % figure 16
        %plot(waveNumbers(1:Npoints),PCALoadings(:,1:4),'-'); 
        % kdk use minPCRComponents
        plot(waveNumbers(1:Npoints),PCALoadings(:,1:minPCRComponents),'-');
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        xlabel('Wavenumber (cm^-^1)');
        myYLabel = 'PCA Loading';
        ylabel(myYLabel);

        switch minPCRComponents
            case 1
                legend({'1st Component'},  ...
                    'location','NW');
            case 2
                legend({'1st Component' '2nd Component'}, 'location','NW');
            case 3
                legend({'1st Component' '2nd Component' '3rd Component'}, ...
                    'location','NW');
            case 4
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component'}, 'location','NW');
            case 5
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component'}, 'location','NW');
            case 6
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component'}, ...
                    'location','NW');
            case 7
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component'}, 'location','NW');
            case 8
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component'}, 'location','NW');
            case 9
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component' '9th Component'}, ....
                    'location','NW');
            case 10
                legend({'1st Component' '2nd Component' '3rd Component' ...
                    '4th Component' '5th Component' '6th Component' ...
                    '7th Component' '8th Component' '9th Component' ...
                    '10th Component'}, 'location','NW');
            otherwise
                fprintf('unrecognized minPCRComponents %d\n', minPCRComponents);
        end
        xlim([min(waveNumbers) max(waveNumbers)]);
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %% kdk: Test the models 
        % with single points: classification and detection of overfitting
        % For a spectra of unknown pH, create new spectra from linear combination
        % of the first N PCs as: b(i) = PC1(i)*a(i) + PC2*a(i) + PC3(i)*a(i) + ...,
        % i = 1, Npoints
        % Then, "fit" this new spectra, b(i) against the spectra of known pH to
        % determine pH of b(i), where I am not sure what "fit" does, but ideally
        % b(i) transforms into a single point on the response curve so that pH can
        % be read off. To figure this out, go back to how the PCR is done, i.e. how
        % is the "observed response" calculated to be 1 value for a spectrum?
        % 
        % Idea: test the PCA models with "min" and 10 PCs on individual Raman spectra already input
        % kdk decide to define "min" generically 
        testFitPCRminPCs = zeros(1, Nspectra, 'double');
        testFitPCR10PCs = zeros(1, Nspectra, 'double');
        testFitPLSminPCs = zeros(1, Nspectra, 'double');
        testFitPLS10PCs = zeros(1, Nspectra, 'double');
        for k=1:Nspectra
            testSpectrum = ramanSpectra(k,:);

            testFitPCRminPCs(k) = [1 testSpectrum] * betaPCR;
            testFitPCR10PCs(k) = [1 testSpectrum] * betaPCR10;

            testFitPLSminPCs(k) = [1 testSpectrum] * betaPLS;
            testFitPLS10PCs(k) = [1 testSpectrum] * betaPLS10;    
        end
        figure % figure 17

        % kdk use minPLSComponents and minPCR Components 
        plot((1:Nspectra),testFitPCRminPCs, 'o');
        hold on;
        plot((1:Nspectra),testFitPCR10PCs, '^');
        hold on;
        plot((1:Nspectra),testFitPLSminPCs, 's');
        hold on;
        plot((1:Nspectra),testFitPLS10PCs, 'p');
        hold on;
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        % kdk: plot the models using the min and 10 components
        myLegend1 = sprintf('PCR %d component model', minPCRComponents);
        myLegend2 = sprintf('PLS %d component model', minPLSComponents);
        legend({myLegend1 'PCR 10 component model' ...
                myLegend2 'PLS 10 component model'},'location','NW');
        if myOption == 2 
            xlabel('Raman test spectra by number for range of [AuNPs] and [analyte]');
        else
            xlabel('Raman test spectra by index, five spectra per pH');
        end
        myYLabel = sprintf('Resultant classification from model');
        ylabel(myYLabel);
        grid on
        myTitle = sprintf('%s Classification test results 1', analyteNames(analyteChoice));
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        
        % Now plot same results again but this time vs analyte conc
        figure
        
        plot(analyte,testFitPCRminPCs, 'o');
        hold on;
        plot(analyte,testFitPCR10PCs, '^');
        hold on;
        plot(analyte,testFitPLSminPCs, 's');
        hold on;
        plot(analyte,testFitPLS10PCs, 'p');
        hold on;
        set(gca,'FontSize',20,'FontWeight','bold','box','off');
        % kdk: plot the models using the min and 10 components
        myLegend1 = sprintf('PCR %d component model', minPCRComponents);
        myLegend2 = sprintf('PLS %d component model', minPLSComponents);
        legend({myLegend1 'PCR 10 component model' ...
                myLegend2 'PLS 10 component model'},'location','NW');
        if myOption == 2 
            xlabel('Raman test spectra for range of [analyte]');
        else
            xlabel('Raman test spectra by index, five spectra per pH');
        end
        myYLabel = sprintf('Resultant classification from model');
        ylabel(myYLabel);
        grid on
        myTitle = sprintf('%s Classification test results 2', analyteNames(analyteChoice));
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);
        %%
        % For either PLSR or PCR, it may be that each component can be given a
        % physically meaningful interpretation by inspecting which variables it
        % weights most heavily.  For instance, with these spectral data it may be
        % possible to interpret intensity peaks in terms of compounds present in
        % the gasoline, and then to observe that weights for a particular component
        % pick out a small number of those compounds.  From that perspective, fewer
        % components are simpler to interpret, and because PLSR often requires
        % fewer components to predict the response adequately, it leads to more
        % parsimonious models.
        % 
        % On the other hand, both PLSR and PCR result in one regression coefficient
        % for each of the original predictor variables, plus an intercept.  In that
        % sense, neither is more parsimonious, because regardless of how many
        % components are used, both models depend on all predictors.  More
        % concretely, for these data, both models need 401 spectral intensity
        % values in order to make a prediction.
        %
        % However, the ultimate goal may to reduce the original set of variables to
        % a smaller subset still able to predict the response accurately.  For
        % example, it may be possible to use the PLS weights or the PCA loadings to
        % select only those variables that contribute most to each component.  As
        % shown earlier, some components from a PCR model fit may serve
        % primarily to describe the variation in the predictor variables, and may
        % include large weights for variables that are not strongly correlated with
        % the response. Thus, PCR can lead to retaining variables that are
        % unnecessary for prediction.
        %
        % For the data used in this example, the difference in the number of
        % components needed by PLSR and PCR for accurate prediction is not great,
        % and the PLS weights and PCA loadings seem to pick out the same variables.
        % That may not be true for other data.
    end % fullAnalysis
end

%% kdk: Functions for data input and processing
function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    global myDebug
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
    end
    
    % check that numPointsIntegrated is in range
    lowEnd = closestRef - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = closestRef + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        end
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    if myDebug
        fprintf('denominator: %g\n', denominator);
    end
    d = denominator;
end

function [e f] = correctBaseline(tics)
    lambda=1e4; % smoothing parameter
    p=0.001; % asymmetry parameter
    d=2;
    % asym: Baseline estimation with asymmetric least squares using weighted
    % smoothing with a finite difference penalty.
    %   signals: signal, each column represents one signal
    %   lambda: smoothing parameter (generally 1e5 to 1e8)
    %   p: asymmetry parameter (generally 0.001)
    %   d: order of differences in penalty (generally 2)
    temp_tic=asysm(tics,lambda,p,d);
    trend=temp_tic';
    modified=tics(:)-temp_tic(:);
    e = trend;
    f = modified';
end   

function [waveNumbers, ramanSpectra, analyte] = getSPIERamanSpectra()
    global numPoints;
    numPoints = 1024;
%     global xRef;
    % Use: index where the MBA reference peak is COO- at 1582
    xRef = analyteMaxPeakLocation(1);
    % xRef = 0; % override index if no normalization is desired
    global offset;
    offset = 300;
    global xMin;
    global xMax;
    global yMin;
    global yMax;
    xMin = 950;
    xMax = 1800;
    yMin = 0;
    yMax = 20.0;
    global myDebug;
    myDebug = 0;
    
    dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\";
    subDirStem = ["pH4 punch1\1"; "pH4.5 punch1\1"; "pH5 punch1\1"; ...
        "pH5.5 punch1\1"; "pH6 punch1\1"; "pH6.5 punch1\1"; ...
        "pH7 punch1\1"; "pH7.5 punch1\1"];
    pHValues = [4.; 4.5; 5; 5.5; 6; 6.5; 7; 7.5];
    ramanSpectra = [];
    analyte = [];
    
    for J = 1:8
        sum = zeros(1, numPoints, 'double');
        avg = zeros(1, numPoints, 'double');
        sumSq = zeros(1, numPoints, 'double');
        thisdata = zeros(2, numPoints, 'double');   
        
        str_dir_to_search = dirStem + subDirStem(J); % args need to be strings
        dir_to_search = char(str_dir_to_search);
        txtpattern = fullfile(dir_to_search, 'avg*.txt');
        dinfo = dir(txtpattern); 

        numberOfSpectra = length(dinfo);
        if numberOfSpectra > 0
            % first pass on dataset, to get array of average spectra
            for I = 1 : numberOfSpectra
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);

                % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                % REFERENCE INDEX

                % 1. Correct the baseline BEFORE calculating denominator + normalizing
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata(2,:)');    

                % 2. Ratiometric
                % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                % on either side of refWaveNumber. This maps to: 1 - 11 total
                % intensities used to calculate the denominator.
                if (xRef ~= 0) 
                    numPointsEachSide = 2;
                    denominator1 = getDenominator(xRef, numPointsEachSide, ...
                        numPoints, f(:));
                else
                    denominator1 = 1;
                end
                if myDebug
                    fprintf('denominator = %g at index: %d\n', denominator1, xRef);
                end

                % 3. NEW 10/4/18: Normalize what is plotted
                normalized = f/denominator1;

                sum = sum + normalized;
            end

            % calculate average
            %avg = sum/numberOfSpectra;

            % second pass on dataset to get (each point - average)^2
            % for standard deviation, need 
            for I = 1 : numberOfSpectra
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);

                % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                % REFERENCE INDEX

                % 1. Correct the baseline BEFORE calculating denominator + normalizing
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata(2,:)');    

                % 2. Ratiometric
                % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                % on either side of refWaveNumber. This maps to: 1 - 11 total
                % intensities used to calculate the denominator.
                if (xRef ~= 0) 
                    numPointsEachSide = 2;
                    denominator1 = getDenominator(xRef, numPointsEachSide, ...
                        numPoints, f(:));
                else
                    denominator1 = 1;
                end
                if myDebug
                    fprintf('denominator = %g at index: %d\n', denominator1, xRef);
                end

                % 3. Normalize what is plotted
                normalized = f/denominator1;
                % one more time to account for fact that > 1 point under
                % curve is used
                normalized = normalized/max(normalized);

                % 4. Add to the sum of the squares
                % sumSq = sumSq + (normalized - avg).^2; 
                % store the corrected signal, throwing away offset points at
                % the start
                
                waveNumbers = thisdata(1,offset:end);
                ramanSpectra = [ramanSpectra; normalized(offset:end)];
                analyte = [analyte; pHValues(J)];
                fprintf('%d\n', I);
            end

            % 5. Compute standard deviation at each index of the averaged spectra 
            % stdDev = sqrt(sumSq/numberOfSpectra);
        end
    end
end

function pHC = pHColor(i)
    % Colors:
    global black;
    global purple;
    global blue;
    global ciel;
    global green;
    global rust;
    global gold;
    global red;
    global cherry;
    global magenta;

    if i < 6
        pHC = black;
    else
        if i < 11
            pHC = magenta;
        else
            if i < 16
                pHC = red;
            else
                if i < 21
                    pHC = gold;
                else
                    if i < 26
                        pHC = green;
                    else
                        if i < 31
                            pHC = ciel;
                        else
                            if i < 36
                                pHC = blue;
                            else
                                pHC = purple;
                            end
                        end
                    end
                end
            end
        end
    end         
end

function [spectra, analyteArr] = getNIHRamanSpectra(analyteChoice)  
    global numPoints
    global batchStart
    global batchEnd
    
    numPoints = 1024;

    % New 2020/12/11 USE THE RIGHT PEAK FOR NORMALIZATION, THIS IS 0 FOR ANALYTES W/O
    % SIGNAL > PLATE. This is actually not so useful, since normalization 
    % boosts the signal of the blank 
    xRef = analyteMaxPeakLocation(analyteChoice);
    % Revert back
    xRef = 0;
    
    global offset
    offset = 300;
    global xMin
    global xMax
    global yMin
    global yMax
    xMin = 950;
    xMax = 1800;
    yMin = 0;
    yMax = 20.0;
    global batchNames
    global conc
    conc = [10]; % refers to AuNPs concentration
    global useBlanks
    global myOption
    
    switch myOption
        case 2
            dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
            dir_to_search = char(dirStem);
            % Patterns to match
            % 'BATCH i*.csv', i = A,B,C
            % 'BATCH i conci*.csv, conci = 0.01, 0.1, 1, 10
            % 'BATCH i conci analytei.csv, analytei = blank,adenosine,lactate,
            %     glucose, glutamate, dopamine, creatinine, uric acid, urea
            % 'BATCH i conci analytei samplei.csv, samplei = 1,..5 (missing for blank)

            % deal with analyte
            analyteArr = [];
            spectra = [];

            Kstart = 1;
            Kend = 5;
            % special handling for R6G where spectra numbered from 2-6, instead
            % of 1-5
            if analyteChoice == 10
                Kstart = 2;
                Kend = 6;
            end

            % kdk: 2020/11/10 TO DO START HERE there is a problem here
            % concentration here is of the AuNPs
            % but the regression model is supposed to use conc of analyte
            % so this needs to change
            % Also, the conc of analyte is different per each analyte, so a 
            % table is needed. See slide 8 of 
            % https://docs.google.com/presentation/d/1yiE2rx4PP9cGM8Y6xsBAFFPp3OfbRk-D1p_wl8mfYzY/edit?usp=sharing

            for J = batchStart:batchEnd %2020/12/5 NEW: combine batches
                if useBlanks == 1
                    filename = sprintf('Batch %s 10-*blank.csv', batchNames(J));
                    [~, newSpectrum] = addOneSpectrum(dir_to_search, filename, xRef);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0];
                end
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s 10-*%s %d.csv', ...
                        batchNames(J), ...
                        analyteNames(analyteChoice), K);
                    [~, newSpectrum] = addOneSpectrum(dir_to_search, filename, xRef);
                    spectra = [spectra; newSpectrum];

                    % 2020/12/10 there is an error here for case of analyteChoice
                    % #10, R6G. Using K is 1 too many. Fix with special handling
                    if (analyteChoice == 10)
                        analyteArr = [analyteArr; K-1]; 
                    else
                        analyteArr = [analyteArr; K];  % 2020/12/05 TO DO this needs to be 
                                                   % actual analyte conc instead of
                                                   % just the index of the conc
                    end
                end
            end
        case 3
            global pHNames
            global batchStart
            global batchEnd
            dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\1.1 f\";
            dir_to_search = char(dirStem);
            % deal with analyte
            analyteArr = [];
            spectra = [];

            Kstart = 1;
            Kend = 3; % the number of repeats per spectrum 
            for I = 1:3
                for J = batchStart:batchEnd
                    for K = Kstart:Kend % each sample
                        filename = sprintf('MBA NPs %d-*%s %d.csv', I, char(pHNames(J)), K);
                        [~, newSpectrum] = addOneSpectrum(dir_to_search, filename, xRef);
                        spectra = [spectra; newSpectrum];

                        switch J
                            case 1
                                analyteArr = [analyteArr; 4];
                            case 2
                                analyteArr = [analyteArr; 5];
                            case 3
                                analyteArr = [analyteArr; 5.5];
                            case 4
                                analyteArr = [analyteArr; 6];
                            case 5
                                analyteArr = [analyteArr; 6.5];
                            case 6
                                analyteArr = [analyteArr; 7];
                        end
                    end
                end
            end
    end
end

function blanksAllBatches = getNIHRamanSpectraBlanks()
    global batchNames
    global waveNumbers
    global batchStart
    global batchEnd
    
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
    dir_to_search = char(dirStem);
    blank = [];
    blanksAllBatches = [];
    xRef = 0;
    
    for batchChoice = batchStart:batchEnd
        filename = sprintf('Batch %s 10-*blank.csv', batchNames(batchChoice));
        [wn blank] = addOneSpectrum(dir_to_search, filename, xRef); % does baseline corr
        waveNumbers = wn;
        blanksAllBatches = [blanksAllBatches; blank];
    end             
end

function allBlackPlates = getNIHRamanSpectraBlackPlates()
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
    dir_to_search = char(dirStem);
    xRef = 0;
    
    % set up the blanks (which show that AuNPs alone don't have a signal)
    % Do this regardless of whether blanks are being used in the analysis
    % or not
    plate = [];
    allBlackPlates = [];
    
    for i = 1:3
        filename = sprintf('black plate%d*.csv', i);
        [~, plate] = addOneSpectrum(dir_to_search, filename, xRef); % does baseline corr
        allBlackPlates = [allBlackPlates; plate];
    end
end

function allBlackPlatesAndWater = getNIHRamanSpectraBlackPlatesAndWater()
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
    dir_to_search = char(dirStem);
    xRef = 0;
    
    % set up the blanks (which show that AuNPs alone don't have a signal)
    % Do this regardless of whether blanks are being used in the analysis
    % or not
    water = [];
    allBlackPlatesAndWater = [];
    filename = 'water*.csv';
    [~, water] = addOneSpectrum(dir_to_search, filename, xRef); % does baseline corr
    allBlackPlatesAndWater = [allBlackPlatesAndWater; water];            
end

function [wn, rs] = readCSV(thisfilename)
%     Tbl = readtable(thisfilename);
%     Vars = Tbl.Properties.VariableNames;
    fprintf('Reading %s\n', thisfilename);
    f = fopen(thisfilename);
    thisdata = textscan(f, '%f %f', 'Delimiter', ',', 'HeaderLines', 34);
    fclose(f);
    wn = cell2mat(thisdata(1,1));
    rs = cell2mat(thisdata(1,2));
end

function [wn b] = addOneSpectrum(dir_to_search, filename, xRef)
    global numPoints
    global waveNumbers
    
    txtpattern = fullfile(dir_to_search, filename);
    dinfo = dir(txtpattern);            
    [wn, an] = readCSV(strcat(dir_to_search,dinfo.name));
    waveNumbers = wn; % 2021/03/10 needed for option 3
    % 1. Correct the baseline BEFORE calculating denominator + normalizing
    % Returns trend as 'e' and baseline corrected signal as 'f'
    [e, f] = correctBaseline(an);
    % 2. Ratiometric
    % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
    % on either side of refWaveNumber. This maps to: 1 - 11 total
    % intensities used to calculate the denominator.
    if (xRef ~= 0) 
        numPointsEachSide = 2;
        denominator1 = getDenominator(xRef, numPointsEachSide, ...
            numPoints, f(:));
        normalized = f/denominator1;
        % one more time to account for fact that > 1 point under
        % curve is used
        b = normalized/max(normalized);
    else
        b = f; % just pass back the baseline corrected spectra
               % OPTION=useful for comparing across analytes,
               % change this to b = f/max(f);
    end
end

function c = analyteMaxPeakLocation(analyteChoice)
    switch analyteChoice
        case 1
            % pH
            c = 713;
        case 2
            % adenosine
            c = 0;
        case 3
            % creatinine
            c = 612;
        case 4
            % dopamine
            c = 521;
        case 5
            % glucose
            c = 0;
        case 6
            % glutamate
            c = 0;
        case 7
            % lactate
            c = 581;
        case 8
            % urea
            c = 0;
        case 9
            % uric acid
            c = 0;
        case 10
            % R6G
            c = 570;
        otherwise
            fprintf('Error analyteChoice %d out of range', analyteChoice);
            c = 0;
    end
end

function d = analyteNames(analyteChoice)
    switch analyteChoice
        case 1
            d = 'pH';
        case 2
            d = 'adenosine';
        case 3
            d = 'creatinine';
        case 4
            d = 'dopamine';
        case 5
            d = 'glucose';
        case 6
            d = 'glutamate';
        case 7
            d = 'lactate';
        case 8
            d = 'urea';
        case 9
            d = 'uric acid';
        case 10
            d = 'R6G';
        otherwise
            fprintf('Error analyteChoice %d out of range', analyteChoice);
            d = 'unrecognized';
    end
end

function g = saveMyPlot(analyteChoice, gcf, myTitle, myYLabel)
    global figureNumber
    figureNumber = figureNumber + 1;
    if analyteChoice > 0
        % kdk: need 2 backslashes to avoid misinterp as ctrl char by
        % sprintf
        subDir = sprintf('%s\\', analyteNames(analyteChoice));
    else
        subDir = 'blanks\';
    end
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);

    myPlot = sprintf('%s%s %s %d.png', plotDirStem, myTitle, myYLabel, ...
        figureNumber);
    saveas(gcf, myPlot);
    g = 1;
end