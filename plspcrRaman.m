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

% kdk: Colors:
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

% kdk: RGB
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

global batchNames
batchNames = ['A'; 'B'; 'C'];
global conc
conc = [0.01; 0.1; 1; 10]; % refers to AuNPs concentration
global rsquaredPCRTable
global rsquaredPLSTable
rsquaredPCRTable = [];
rsquaredPLSTable = [];
% global analyteStart
% global analyteEnd
% CHOOSE analytes to use
% if myAnalysis == 1 CHOOSE 1 (pH)
% if myAnalysis == 2 CHOOSE from 2 to 10 (get names from "analyteNames" fn)
analyteStart = 2;
analyteEnd = 10;
% global batchStart
% global batchEnd
% CHOOSE how many batches from 1 to 3
batchStart = 1;
batchEnd = 3;
global useBlanks
% CHOOSE: set useBlanks to 1 if you want the spectra of AuNPs alone used in
% the analysis; set useBlanks to 0 if you want to exclude it.
useBlanks = 1;
global figureNumber
figureNumber = 0;
global PCRthreshold
% CHOOSE the accuracy that you want
PCRthreshold = 0.95;
global PLSthreshold
% CHOOSE the accuracy that you want
PLSthreshold = 95;
global myPCR
global myPLS
myPLS = [];
myPCR = [];
global firstTime
firstTime = 1;

global fullAnalysis
%CHOOSE 0 to just draw all the 3d plots, CHOOSE 1 to run the analysis
fullAnalysis = 0;
%% kdk: Clear previous plots

close all

%% Load the Data and Do the Analysis

% kdk 2020/10/26, Change to input Raman spectra
% First, for myAnalysis = 1 case:
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
global myAnalysis
myAnalysis = 2; % CHOOSE 1 for SPIE dataset, CHOOSE 2 for NIH dataset
if myAnalysis == 1
    % Load the data
    [waveNumbers, spectra, analyteArr] = getSPIERamanSpectra();
    % Do the analysis
    analysis(waveNumbers, spectra, analyteArr, 1, 1);
else
    for analyteChoice = analyteStart:analyteEnd
        for batchChoice = batchStart:batchEnd % CHOOSE UP TO 3
            % Load the data
            [waveNumbers, spectra, analyteArr] = getNIHRamanSpectra(...
                analyteChoice, batchChoice);
            % Do the analysis
            analysis(waveNumbers, spectra, analyteArr, analyteChoice, ...
                batchChoice);
        end
    end
    
    if fullAnalysis == 1
        % kdk: Add tabulation of correlation values for PCR and PLS
        % kdk: Add numbers of components for the desired explained var (PLS)
        % and % coverage by the PCR
        for analyteChoice = analyteStart:analyteEnd
            fprintf('analyte: %s batches: %s, %s, %s\n', analyteNames(analyteChoice), ...
                batchNames(1), batchNames(2), batchNames(3));
            fprintf('PLS rsquared using %d PCs ', myPLS(analyteChoice, batchChoice));
            for batchChoice = batchStart:batchEnd
                fprintf('%f ', rsquaredPLSTable(analyteChoice, batchChoice));
            end
            fprintf('\n');
            fprintf('PCR rsquared using %d PCs ', myPCR(analyteChoice, batchChoice));
            for batchChoice = batchStart:batchEnd
                fprintf('%f ', rsquaredPCRTable(analyteChoice, batchChoice));
            end
            fprintf('\n');
        end
    end
end

% end of main

function c = analysis(waveNumbers, ramanSpectra, analyte, analyteChoice, batchChoice)
    global myPCR
    global myPLS
    global batchNames
    global rsquaredPCRTable
    global rsquaredPLSTable
    global conc
    global PCRthreshold
    global PLSthreshold
    global firstTime
    global blankD01
    global blankD1
    global blank1
    global blank10
    global useBlanks
    global fullAnalysis
    global myAnalysis
    
    if myAnalysis == 2 && firstTime == 1 % this is only relevant for NIH data
        % plot the blanks (the same blanks are used for all analytes, so
        % just do this once
        figure % figure 1
        plot(waveNumbers(1:size(blankD01))',blankD01);
        hold on;
        plot(waveNumbers(1:size(blankD01))',blankD1);
        hold on;
        plot(waveNumbers(1:size(blankD01))',blank1);
        hold on;
        plot(waveNumbers(1:size(blankD01))',blank10);
        hold on;
        
        xlabel('Wavenumber (cm^-^1)'); 
        myYLabel = sprintf('Intensity (A.U.)');
        ylabel(myYLabel); axis('tight');
        grid on
        myTitle = sprintf('Raw blanks for all concentrations of AuNPs');
        title(myTitle);
        legend({'0.01 nM' '0.1 nM' '1 nM' '10 nM'}, 'location','SW');
        saveMyPlot(0, gcf, myTitle, 'all blanks');
        firstTime = 0;
    end
    
    figure
    myTitle = sprintf('%s Batch %s', analyteNames(analyteChoice), batchNames(batchChoice));
    
    % adjust title for the NIH dataset
    if myAnalysis == 2 && useBlanks == 1
        myTitle = sprintf('%s Batch %s with blanks', ...
            analyteNames(analyteChoice), batchNames(batchChoice));
    else
        if myAnalysis == 2 && useBlanks == 0
            myTitle = sprintf('%s Batch %s without blanks', analyteNames(analyteChoice), batchNames(batchChoice));
        end
    end
    fprintf('%s\n', myTitle);
    % kdk: use same approach for both SPIE and NIH datasets
    [Nspectra, Npoints] = size(ramanSpectra); 
    [~, h] = sort(analyte); % actually not necess since data read in order
    oldorder = get(gcf,'DefaultAxesColorOrder');
    set(gcf,'DefaultAxesColorOrder',jet(Nspectra));
    if myAnalysis == 1 % kdk: TO DO why needed?
        x1 = repmat(waveNumbers(1:Npoints),Nspectra,1)';
    else
        x1 = repmat(waveNumbers(1:Npoints)',Nspectra,1)';
    end
    y1 = repmat(analyte(h),1,Npoints)';
    z1 = ramanSpectra(h,:)';
    plot3(x1, y1, z1); % figure 1
    set(gcf,'DefaultAxesColorOrder',oldorder);
    % kdk: given concs are multiples of 10, semilog is better
    set(gca,'YScale','log');
    xlabel('Wavenumber (cm^-^1)'); 
    ylabel('concentration of AuNPs (nM)'); axis('tight'); % kdk TO DO what is 'tight'?
    zlabel('Intensity (A.U.)');
    grid on
    title(myTitle);
    saveMyPlot(analyteChoice, gcf, myTitle, 'all spectra w blanks 3D');

    %% kdk NEW: let's zoom in on just the 10 nM conc of NPs
    % and spread out the concs of analytes, instead of plotting them
    % at the same y value
    if myAnalysis == 2    
        % kdk: NEW brought from above
        figure
        x1 = repmat(waveNumbers(1:Npoints)',6,1)';
        y1 = repmat((0:5)',1,Npoints)'; % use LUT to get actual analyte conc
        z1 = ramanSpectra(19:24,:)';
        plot3(x1, y1, z1); % figure 1
        set(gcf,'DefaultAxesColorOrder',oldorder);
        xlabel('Wavenumber (cm^-^1)'); 
        ylabel('concentration of analyte'); axis('tight'); % kdk TO DO what is 'tight'?
        zlabel('Intensity (A.U.)');
        grid on
        myTitle2 = sprintf('%s Batch %s with blank for [AuNP]=10nM', ...
        analyteNames(analyteChoice), batchNames(batchChoice));
        title(myTitle2);
        saveMyPlot(analyteChoice, gcf, myTitle, 'all spectra at 10 nM AuNPs 3D');
    end
    
    if fullAnalysis == 1
        %% kdk: Draw the sets of spectra at each conc'n on their own plot
        iiStart = 1;
        if useBlanks == 1
            iiEnd = iiStart + 5;
        else
            iiEnd = iiStart + 4;
        end

    %     offset = 0; % Indicates low end of the wavenumbers to be discarded
        if myAnalysis == 2    
            for jj = 1:4 % all concs
                fprintf('Loop for conc %d start = %d, end = %d\n', ...
                    jj, iiStart, iiEnd);
                figure % figure 2,3,4,5
                for ii = iiStart:iiEnd 
                    plot(waveNumbers(1:Npoints)',ramanSpectra(ii,:)');
                    pause(1);
                    hold on;
                end

                set(gcf,'DefaultAxesColorOrder',oldorder);
                xlabel('Wavenumber (cm^-^1)'); 
                myYLabel = sprintf('Normalized Intensity at conc %.2f nM AuNPs', conc(jj));
                ylabel(myYLabel); axis('tight');
                grid on
                title(myTitle);
                if myAnalysis == 2 && useBlanks == 1
                    hleg = legend({'0' '1' '2' '3' '4' '5'}, 'location','NE');
                else
                    if myAnalysis == 2 && useBlanks == 0
                        hleg = legend({'1' '2' '3' '4' '5'}, 'location','NE');
                    end
                end
                if myAnalysis == 2
                    htitle = get(hleg,'Title');
                    set(htitle,'String','Analyte concentration')
                end

                % kdk: save figure
                % ugh, if I use the label containing a '.', saveas interprets this
                % as file type delimiter, so change from using the actual conc
                % values to using 'D' for decimal point.
                switch jj
                    case 1
                        myYLabel = 'conc D01nm AuNPs';
                    case 2
                        myYLabel = 'conc D1nm AuNPs';
                    case 3
                        myYLabel = 'conc 1nm AuNPs';
                    case 4
                        myYLabel = 'conc 10nm AuNPs';
                end
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
        
        %% Fitting the Data with Ten and then a data driven number of PLS Components
        % Use the |plsregress| function to fit a PLSR model with ten PLS components
        % and one response.
        X = ramanSpectra;
        y = analyte;
        [n,p] = size(X);
        % kdk: prior to choosing the optimal, take a look at up to 10 components
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
        fprintf('#PLS components explaining 90 percent of variance = %d\n', minPLSComponents);
        xlabel('Number of PLS components');
        myYLabel = 'Percent Variance Explained in Y';
        ylabel(myYLabel);
        grid on
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

        while PCAVar(ii) ~= 0 && minPCRComponents == 0
            sumSoFar = sumSoFar + fractionEigenValues(ii);
            if sumSoFar > PCRthreshold
                minPCRComponents = ii;
            end
            ii = ii + 1;
        end
        fprintf('#PCR components explaining 90 percent of variance = %d\n', minPCRComponents);
        betaPCR = regress(y-mean(y), PCAScores(:,1:minPCRComponents)); 
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
        % Plot fitted vs. observed response for the PLSR and PCR fits.
        figure % figure 7
        for ii = 1:Nspectra
            % kdk TO DO: are these colors good for all analytes?
            plot(y(ii),yfitPLS(ii),'o','Color',pHColor(ii));
            hold on;
            plot(y(ii),yfitPCR(ii),'^','Color',pHColor(ii));
            hold on;
        end
        xlabel('Observed Response');
        myYLabel = 'Fitted Response';
        ylabel(myYLabel);
        plsLegend = sprintf('PLSR with %d Components', minPLSComponents);
        pcrLegend = sprintf('PCR with %d Components', minPCRComponents);
        legend({plsLegend pcrLegend}, 'location','NW');
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, myYLabel);  
        myPLS(analyteChoice, batchChoice) = minPLSComponents;
        myPCR(analyteChoice, batchChoice) = minPCRComponents;
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
        rsquaredPLSTable(analyteChoice, batchChoice) = rsquaredPLS;
        %%
        RSS_PCR = sum((y-yfitPCR).^2);
        rsquaredPCR = 1 - RSS_PCR/TSS; % kdk TO DO: save this to an array for tabulating
        rsquaredPCRTable(analyteChoice, batchChoice) = rsquaredPCR;
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
        plot(y,yfitPLS10,'bo',y,yfitPCR10,'r^');
        xlabel('Observed Response');
        ylabel('Fitted Response');
        legend({'PLSR with 10 components' 'PCR with 10 Components'},  ...
            'location','NW');
        grid on
        title(myTitle);
        saveMyPlot(analyteChoice, gcf, myTitle, 'PLS and PCR response');
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
        % kdk: TO DO START HERE need a way to choose the number of components, based on 
        % fraction of full range
        figure % figure 12
        % plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^'); kdk: MJM catches badness of
        % claiming to use 0 components, but why are there 11 anyway?
        plot(1:11,PLSmsep(2,:),'b-o',1:11,PCRmsep,'r-^');
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
        minPLSComponents = 5; % 2020/11/13 - just to plot them all
        [Xl,Yl,~,Ys,beta,pctVar,mse,stats] = plsregress(X,y,minPLSComponents);
        figure % figure 13
        % plot(1:Npoints,stats.W,'-'); % original
        plot(waveNumbers(1:Npoints),stats.W,'-'); % kdk use wavenumbers
        xlabel('Wavenumber (cm^-^1)');
        myYLabel = 'PLS Weight';
        ylabel(myYLabel);

        switch minPLSComponents
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
        minPCRComponents = 5; % 2020/11/13 - just to plot them all
        plot(waveNumbers(1:Npoints),PCALoadings(:,1:minPCRComponents),'-');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('PCA Loading');
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
        % kdk: plot the models using the min and 10 components
        myLegend1 = sprintf('PCR %d component model', minPCRComponents);
        myLegend2 = sprintf('PLS %d component model', minPLSComponents);
        legend({myLegend1 'PCR 10 component model' ...
                myLegend2 'PLS 10 component model'},'location','NW');
        % kdk TO DO: START HERE why are there a whole bunch more items in
        % legend?
        if myAnalysis == 2 
            xlabel('Raman test spectra by number for range of [AuNPs] and [analyte]');
        else
            xlabel('Raman test spectra by index, five spectra per pH');
        end
        myYLabel = sprintf('Resultant classification from model');
        ylabel(myYLabel);
        grid on
        myTitle = sprintf('%s Batch %s Classification test', analyteNames(analyteChoice), batchNames(batchChoice));
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
    global xRef;
    % CHOOSE: index where the MBA reference peak is COO- at 1582
    xRef = 713; % 
    % xRef = 0; % index to use if no normalization is desired
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
                pHC = cherry;
            else
                if i < 21
                    pHC = red;
                else
                    if i < 26
                        pHC = rust;
                    else
                        if i < 31
                            pHC = gold;
                        else
                            if i < 36
                                pHC = green;
                            else
                                pHC = ciel;
                            end
                        end
                    end
                end
            end
        end
    end         
end

function [waveNumbers, spectra, analyteArr] = getNIHRamanSpectra(...
    analyteChoice, batchChoice)  
    global numPoints
    numPoints = 1024;
    global xRef
    % CHOOSE THE RIGHT PEAK FOR NORMALIZATION
    % xRef = 713; % MBA ONLY: reference peak is COO- at 1582
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
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
    dir_to_search = char(dirStem);
    global useBlanks

    % Patterns to match
    % 'BATCH i*.csv', i = A,B,C
    % 'BATCH i conci*.csv, conci = 0.01, 0.1, 1, 10
    % 'BATCH i conci analytei.csv, analytei = blank,adenosine,lactate,
    %     glucose, glutamate, dopamine, creatinine, uric acid, urea
    % 'BATCH i conci analytei samplei.csv, samplei = 1,..5 (missing for blank)
    
    % Make these global so they can be plotted indep of analyte spectra
    global blankD01
    global blankD1
    global blank1
    global blank10
    
    % set up the blanks (which show that AuNPs alone don't have a signal)
    % Do this regardless of whether blanks are being used in the analysis
    % or not
    blankD01 = [];
    blankD1 = [];
    blank1 = [];
    blank10 = [];
    
    filename = sprintf('Batch %s 0.01-*blank.csv', batchNames(batchChoice));
    txtpattern = fullfile(dir_to_search, filename);
    dinfo = dir(txtpattern);
    [waveNumbers blankD01] = readCSV(strcat(dir_to_search,dinfo.name));

    filename = sprintf('Batch %s 0.1-*blank.csv', batchNames(batchChoice));
    txtpattern = fullfile(dir_to_search, filename);
    dinfo = dir(txtpattern);
    [wn blankD1] = readCSV(strcat(dir_to_search,dinfo.name));

    filename = sprintf('Batch %s 1-*blank.csv', batchNames(batchChoice));
    txtpattern = fullfile(dir_to_search, filename);
    dinfo= dir(txtpattern);
    [wn blank1] = readCSV(strcat(dir_to_search,dinfo.name));

    filename = sprintf('Batch %s 10-*blank.csv', batchNames(batchChoice));
    txtpattern = fullfile(dir_to_search, filename);
    dinfo = dir(txtpattern);
    [wn blank10] = readCSV(strcat(dir_to_search,dinfo.name));

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
    for J = 1:4 % each concentration 
        switch J
            case 1
                if useBlanks == 1
                    %spectra = [spectra; blankD01']; WRONG! missing
                    %baseline correction, normalization
                    filename = sprintf('Batch %s 0.01-*blank.csv', batchNames(batchChoice));
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr 0.0];
                end
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.2f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.01];
                end

            case 2
                if useBlanks == 1
                    %spectra = [spectra; blankD1']; WRONG! missing
                    %baseline correction, normalization
                    filename = sprintf('Batch %s 1-*blank.csv', batchNames(batchChoice));
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.0];
                end
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.1f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.1];
                end

            case 3
                if useBlanks == 1
                    %spectra = [spectra; blank1']; WRONG! missing
                    %baseline correction, normalization
                    filename = sprintf('Batch %s 1-*blank.csv', batchNames(batchChoice));
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.0];
                end
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.0f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 1];
                end

            case 4
                if useBlanks == 1
                    %spectra = [spectra; blank10']; WRONG! missing
                    %baseline correction, normalization
                    filename = sprintf('Batch %s 10-*blank.csv', batchNames(batchChoice));
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.0];
                end
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.0f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 10];
                end
        end
    end               
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

function b = addOneSpectrum(dir_to_search, filename)
    global xRef
    global numPoints;
    
    txtpattern = fullfile(dir_to_search, filename);
    dinfo = dir(txtpattern);            
    [wn, an] = readCSV(strcat(dir_to_search,dinfo.name));
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
    myPlot = sprintf('%s%s %s fig%d', plotDirStem, myTitle, myYLabel, figureNumber);
    saveas(gcf, myPlot);
    myPlot = sprintf('%s%s %s fig%d.png', plotDirStem, myTitle, myYLabel, figureNumber);
    saveas(gcf, myPlot);
    g = 1;
end