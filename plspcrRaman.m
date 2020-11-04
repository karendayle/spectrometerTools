%% Partial Least Squares Regression and Principal Components Regression
% This example shows how to apply Partial Least Squares Regression (PLSR)
% and Principal Components Regression (PCR), and discusses the
% effectiveness of the two methods.  PLSR and PCR are both methods to model
% a response variable when there are a large number of predictor variables,
% and those predictors are highly correlated or even collinear.  Both
% methods construct new predictor variables, known as components, as linear
% combinations of the original predictor variables, but they construct
% those components in different ways.  PCR creates components to explain
% the observed variability in the predictor variables, without considering
% the response variable at all. On the other hand, PLSR does take the
% response variable into account, and therefore often leads to models that
% are able to fit the response variable with fewer components.  Whether or
% not that ultimately translates into a more parsimonious model, in terms
% of its practical use, depends on the context.
%
%   Copyright 2008 The MathWorks, Inc.

%   Dayle Kotturi 10/26/2020
%   Modify to input Raman spectra to determine concentration from intensity
%   Add figure command to avoid overwrite
%   Read in the averaged Raman spectra from various dirs
%   Add plot color by pH
%   Adapt for multianalytes, change pH to be generic concentration of 
%   any of the nine analytes. Use "blank" to indicate analyte conc = 0.

% kdk: Colors:
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
global rsquaredPCRTable
global rsquaredPLSTable
rsquaredPCRTable = [];
rsquaredPLSTable = [];
analyteStart = 7;
analyteEnd = 7;

%% kdk: Clear previous plots

close all

%% Loading the Data
% Load a data set comprising spectral intensities of 60 samples of gasoline at
% 401 wavelengths, and their octane ratings.  These data are described in
% Kalivas, John H., "Two Data Sets of Near Infrared Spectra," Chemometrics and
% Intelligent Laboratory Systems, v.37 (1997) pp.255-259.
% load spectra
% whos NIR octane

% kdk 2020/10/26, 27 Input Raman spectra
% - load set of N Raman spectra, each 1024 values long - done
% - use the averaged spectra (with dark removed, baseline
% - corrected) - done
% - normalize too - done
% - normalize again by max - done
% - store the array of 1024 wavenumbers once - done 
% - replace octane with pH level (known) as a float (so sorting is poss) - done
% - figure out why each pH level shows only 1 avg, not 5 - 
% - in the regression and PLS plots, color by original pH

myAnalysis = 2;
if myAnalysis == 1
    [waveNumbers, spectra analyteArr] = getSPIERamanSpectra();
    analysis(waveNumbers, spectra, analyteArr, 1, 1);
else
    for analyteChoice = analyteStart:analyteEnd
        for batchChoice = 1:3
% THIS HAS BEEN FIXED. DELETE AFTER CONFIRMING
%             if analyteChoice == 2 && batchChoice == 2
%                 fprintf('skipping due to missing files for adenosine Batch B conc 0.1\n');
%             else
%                 if analyteChoice == 5 && batchChoice == 3
%                     fprintf('skipping due to missing files for glucose Batch C conc 1\n');
%                 
%                 else
%                     if analyteChoice == 6 && batchChoice == 3
%                         fprintf('skipping due to missing files for glutamate Batch C conc 1\n');
%                     else
                    [waveNumbers, spectra analyteArr] = getNIHRamanSpectra(...
                        analyteChoice, batchChoice);
                    analysis(waveNumbers, spectra, analyteArr, analyteChoice, ...
                        batchChoice);
%                     end
%                 end
%             end
        end
    end
    
    % Tabulate correlation values for PCR and PLS
    for analyteChoice = analyteStart:analyteEnd
        fprintf('analyte: %s', analyteNames(analyteChoice));
        fprintf('PCR');
        for batchChoice = 1:3
            fprintf('%f', rsquaredPCRTable(analyteChoice, batchChoice));
        end
        fprintf('\n');
        fprintf('PLS');
        for batchChoice = 1:3
            fprintf('%f', rsquaredPLSTable(analyteChoice, batchChoice));
        end
        fprintf('\n');
    end
end

% end of main

function c = analysis(waveNumbers, ramanSpectra, analyte, analyteChoice, batchChoice)
    global batchNames
    global rsquaredPCRTable
    global rsquaredPLSTable
    
    myTitle = sprintf('%s Batch %s', analyteNames(analyteChoice), batchNames(batchChoice));
    fprintf('%s\n', myTitle);
    % Proceed with same approach for both SPIE and NIH datasets
    [Nspectra Npoints] = size(ramanSpectra); 
    [dummy,h] = sort(analyte); % sorting actually not necess since data read in order
    oldorder = get(gcf,'DefaultAxesColorOrder');
    set(gcf,'DefaultAxesColorOrder',jet(Nspectra));
    x1 = repmat(waveNumbers(1:Npoints)',Nspectra,1)';
    y1 = repmat(analyte(h),1,Npoints)';
    z1 = ramanSpectra(h,:)';
    plot3(x1, y1, z1); % figure 1
    set(gcf,'DefaultAxesColorOrder',oldorder);
    xlabel('Wavenumber (cm^-^1)'); ylabel(analyteNames(analyteChoice)); axis('tight');
    grid on
    title(myTitle);
    
    %% Check one set of spectra at lowest analyte 
    % above
    figure % figure 2
    for ii = 1:5
      plot(waveNumbers(1:Npoints)',ramanSpectra(ii,:)');
      pause(5);
      hold on;
    end

    %% Fitting the Data with Ten and then Two Components
    % Use the |plsregress| function to fit a PLSR model with ten PLS components
    % and one response.
    X = ramanSpectra;
    y = analyte;
    [n,p] = size(X);
    [Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(...
        X,y,10);

    %%
    % Ten components may be more than will be needed to adequately fit the
    % data, but diagnostics from this fit can be used to make a choice of a
    % simpler model with fewer components. For example, one quick way to choose
    % the number of components is to plot the percent of variance explained in
    % the response variable as a function of the number of components.
    figure % figure 3
    plot(1:10,cumsum(100*PLSPctVar(2,:)),'-bo');
    % kdk TO DO: save lowest number of components that explains > 90% of variance
    minComponents = 0;
    for i = 1:10
        xx = cumsum(100*PLSPctVar(2,1:i));
        if minComponents == 0 && xx(i) > 90
            minComponents = i;
        end
    end
    fprintf('#components explaining 90 percent of variance = %d\n', minComponents);
    xlabel('Number of PLS components');
    ylabel('Percent Variance Explained in Y');
    title(myTitle);
    %%
    % In practice, more care would probably be advisable in choosing the number
    % of components.  Cross-validation, for instance, is a widely-used method
    % that will be illustrated later in this example.  For now, the above plot
    % suggests that PLSR with two components explains most of the variance in
    % the observed |y|.  Compute the fitted response values for the
    % two-component model.
    [Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,2); %kdk TO DO 
    % optimize the number of components
    yfitPLS = [ones(n,1) X]*betaPLS;

    %%
    % Next, fit a PCR model with two principal components.  The first step is
    % to perform Principal Components Analysis on |X|, using the |pca|
    % function, and retaining two principal components. PCR is then just a
    % linear regression of the response variable on those two components.  It
    % often makes sense to normalize each variable first by its standard
    % deviation when the variables have very different amounts of variability,
    % however, that is not done here. (kdk: but I normalized spectra prior)
    % kdk: PCAVar are the eigenvalues. They are used to assess expected var
    [PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
    betaPCR = regress(y-mean(y), PCAScores(:,1:2)); % kdk TO DO replace with optimal 
    %%
    % To make the PCR results easier to interpret in terms of the original
    % spectral data, transform to regression coefficients for the original,
    % uncentered variables.
    betaPCR = PCALoadings(:,1:2)*betaPCR;
    betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
    yfitPCR = [ones(n,1) X]*betaPCR;

    %%
    % Plot fitted vs. observed response for the PLSR and PCR fits.
    figure % figure 4
    %plot(y,yfitPLS,'bo',y,yfitPCR,'r^'); % original, before color
    for ii = 1:Nspectra
    %     plot(y(ii),yfitPLS(ii),'o',y(ii),yfitPCR(ii),'^', ...
    %         'Color',pHColor(ii)); 
        plot(y(ii),yfitPLS(ii),'o','Color',pHColor(ii));
        hold on;
        plot(y(ii),yfitPCR(ii),'^','Color',pHColor(ii));
        hold on;
    end
    xlabel('Observed Response');
    ylabel('Fitted Response');
    legend({'PLSR with 2 Components' 'PCR with 2 Components'},  ...
        'location','NW');
    title(myTitle);
        
    %%
    % In a sense, the comparison in the plot above is not a fair one -- the
    % number of components (two) was chosen by looking at how well a
    % two-component PLSR model predicted the response, and there's no reason
    % why the PCR model should be restricted to that same number of components.
    % With the same number of components, however, PLSR does a much better job
    % at fitting |y|.  In fact, looking at the horizontal scatter of fitted
    % values in the plot above, PCR with two components is hardly better than
    % using a constant model.  The r-squared values from the two regressions
    % confirm that.
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
    figure % figure 5
    % plot3(Xscores(:,1),Xscores(:,2),y-mean(y),'bo'); % original, before color
    for ii = 1:Nspectra
        plot3(Xscores(ii,1),Xscores(ii,2),y-mean(y),'bo', 'Color', pHColor(ii));
        hold on;
    end
    legend('PLSR');
    xlabel('X 1 score'); % kdk
    ylabel('X 2 score'); % kdk
    zlabel('Response Variable');
    grid on; view(-30,30);
    title(myTitle);
     
    %%
    % It's a little hard to see without being able to interactively rotate the
    % figure, but the PLSR plot above shows points closely scattered about a plane.
    % On the other hand, the PCR plot below shows a cloud of points with little
    % indication of a linear relationship.
    figure % figure 6
    % plot3(PCAScores(:,1),PCAScores(:,2),y-mean(y),'r^'); % original, before color
    for ii = 1:Nspectra
        plot3(PCAScores(ii,1),PCAScores(ii,2),y-mean(y),'r^', 'Color', pHColor(ii));
        hold on;
    end
    legend('PCR');
    xlabel('PCA 1 score'); % kdk
    ylabel('PCA 2 score'); % kdk
    zlabel('Response');
    grid on; view(-30,30);
    title(myTitle);

    %%
    % Notice that while the two PLS components are much better predictors of
    % the observed |y|, the following figure shows that they explain
    % somewhat less variance in the observed |X| than the first two principal
    % components used in the PCR.
    figure % figure 7
    plot(1:10,100*cumsum(PLSPctVar(1,:)),'b-o',1:10,  ...
        100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)),'r-^'); % kdk do I care about the percent var in x?
    xlabel('Number of Principal Components');
    ylabel('Percent Variance Explained in X');
    legend({'PLSR' 'PCR'},'location','SE');
    title(myTitle);
    %%
    % The fact that the PCR curve is uniformly higher suggests why PCR with two
    % components does such a poor job, relative to PLSR, in fitting |y|.  PCR
    % constructs components to best explain |X|, and as a result, those first
    % two components ignore the information in the data that is important in
    % fitting the observed |y|.


    %% Fitting with More Components
    % As more components are added in PCR, it will necessarily do a better job
    % of fitting the original data |y|, simply because at some point most of the
    % important predictive information in |X| will be present in the principal
    % components.  For example, the following figure shows that the
    % difference in residuals for the two methods is much less dramatic when
    % using ten components than it was for two components.
    yfitPLS10 = [ones(n,1) X]*betaPLS10;
    betaPCR10 = regress(y-mean(y), PCAScores(:,1:10));
    betaPCR10 = PCALoadings(:,1:10)*betaPCR10;
    betaPCR10 = [mean(y) - mean(X)*betaPCR10; betaPCR10];
    yfitPCR10 = [ones(n,1) X]*betaPCR10;
    figure % figure 8
    plot(y,yfitPLS10,'bo',y,yfitPCR10,'r^');
    xlabel('Observed Response');
    ylabel('Fitted Response');
    legend({'PLSR with 10 components' 'PCR with 10 Components'},  ...
        'location','NW');
    title(myTitle);
    
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
    %%
    % For PCR, |crossval| combined with a simple function to compute the sum of
    % squared errors for PCR, can estimate the MSEP, again using 10-fold
    % cross-validation.
    PCRmsep = sum(crossval(@pcrsse,X,y,'KFold',10),1) / n;

    %%
    % The MSEP curve for PLSR indicates that two or three components does about
    % as good a job as possible.  On the other hand, PCR needs four components
    % to get the same prediction accuracy.
    figure % figure 9
    % plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^'); kdk: MJM catches badness of
    % claiming to use 0 components, but why are there 11 anyway?
    plot(1:11,PLSmsep(2,:),'b-o',1:11,PCRmsep,'r-^');
    xlabel('Number of components');
    ylabel('Estimated Mean Squared Prediction Error');
    legend({'PLSR' 'PCR'},'location','NE');
    title(myTitle);
   
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
    [Xl,Yl,~,Ys,beta,pctVar,mse,stats] = plsregress(X,y,3);
    figure % figure 10
    % plot(1:Npoints,stats.W,'-'); % original
    plot(waveNumbers(1:Npoints),stats.W,'-'); % kdk use wavenumbers
    xlabel('Wavenumber (cm^-^1)');
    ylabel('PLS Weight');
    legend({'1st Component' '2nd Component' '3rd Component'},  ...
        'location','NW');
    xlim([min(waveNumbers) max(waveNumbers)]);
    title(myTitle);
    
    %% kdk NEW plot the residuals in X and Y, color by pH
    figure figure 11
    for ii = 1:Nspectra
        plot(waveNumbers(1:Npoints),stats.Xresiduals(ii,:),'-','Color',pHColor(ii));
        hold on;
    end
    xlabel('Wavenumber (cm^-^1)');
    ylabel('PLS X residuals');
    title(myTitle);
    
    figure % figure 12
    for ii = 1:Nspectra
        plot(analyte(ii),stats.Yresiduals(ii),'^','Color',pHColor(ii));
        hold on;
    end
    xlabel(analyteNames(analyteChoice));
    ylabel('PLS Y residuals');
    title(myTitle);
    
    %%
    % Similarly, the PCA loadings describe how strongly each component in the PCR
    % depends on the original variables.
    figure % figure 13
    plot(waveNumbers(1:Npoints),PCALoadings(:,1:4),'-'); % kdk use wavenumbers
    xlabel('Wavenumber (cm^-^1)');
    ylabel('PCA Loading');
    legend({'1st Component' '2nd Component' '3rd Component'  ...
        '4th Component'},'location','NW');
    xlim([min(waveNumbers) max(waveNumbers)]);
    title(myTitle);
    
    %% kdk: Idea for classification (what comes next)
    % For a spectra of unknown pH, create new spectra from linear combination
    % of the first N PCs as: b(i) = PC1(i)*a(i) + PC2*a(i) + PC3(i)*a(i) + ...,
    % i = 1, Npoints
    % Then, "fit" this new spectra, b(i) against the spectra of known pH to
    % determine pH of b(i), where I am not sure what "fit" does, but ideally
    % b(i) transforms into a single point on the response curve so that pH can
    % be read off. To figure this out, go back to how the PCR is done, i.e. how
    % is the "observed response" calculated to be 1 value for a spectrum?
    % 
    % Idea: test the PCA models with 2 and 10 PCs on individual Raman spectra already input
    testFitPCR2PCs = zeros(1, Nspectra, 'double');
    testFitPCR10PCs = zeros(1, Nspectra, 'double');
    testFitPLS2PCs = zeros(1, Nspectra, 'double');
    testFitPLS10PCs = zeros(1, Nspectra, 'double');
    for k=1:Nspectra
        testSpectrum = ramanSpectra(k,:);
        testFitPCR2PCs(k) = [1 testSpectrum] * betaPCR;
        testFitPCR10PCs(k) = [1 testSpectrum] * betaPCR10;
        testFitPLS2PCs(k) = [1 testSpectrum] * betaPLS;
        testFitPLS10PCs(k) = [1 testSpectrum] * betaPLS10;
    end
    figure % figure 14
    title('Classification test');
    xlabel('Raman spectra test spectra (5 at 8 pH levels)');
    ylabel('Resultant pH classification from model');
    plot((1:Nspectra),testFitPCR2PCs, 'o');
    hold on;
    plot((1:Nspectra),testFitPCR10PCs, '^');
    hold on;
    plot((1:Nspectra),testFitPLS2PCs, 's');
    hold on;
    plot((1:Nspectra),testFitPLS10PCs, 'p');
    hold on;
    legend({'PCR 2 component model' 'PCR 10 component model' ...
            'PLS 2 component model' 'PLS 10 component model'},'location','NW');
    title('Classification test');
    xlabel('Raman spectra test spectra (5 at 8 pH levels)');
    myYLabel = sprintf('Resultant %s classification from model', ...
        analyteNames(analyteChoice));
    ylabel(myYLabel);
    title(myTitle);
    
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

function a = getSPIERamanSpectra()
    global numPoints;
    numPoints = 1024;
    global xRef;
    xRef = 713; % index where the reference peak is 
                    % COO- at 1582
                    % TO DO: read from avg*.txt file
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
    global waveNumbers;
    global ramanSpectra;
    global analyte;
    
    dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\";
    subDirStem = ["pH4 punch1\1"; "pH4.5 punch1\1"; "pH5 punch1\1"; ...
        "pH5.5 punch1\1"; "pH6 punch1\1"; "pH6.5 punch1\1"; ...
        "pH7 punch1\1"; "pH7.5 punch1\1"];
    pHValues = [4.; 4.5; 5; 5.5; 6; 6.5; 7; 7.5];

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
    a = numberOfSpectra;
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

function [waveNumbers spectra analyteArr] = getNIHRamanSpectra(...
    analyteChoice, batchChoice)  

    global numPoints
    numPoints = 1024;
    global xRef
    xRef = 713; % index where the reference peak is 
                % COO- at 1582
                % TO DO: read from avg*.txt file
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
    conc = [0.01; 0.1; 1; 10];
    dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\NIH R21 SERS\Exp 1.1\";
    dir_to_search = char(dirStem);

    % Patterns to match
    % 'BATCH i*.csv', i = A,B,C
    % 'BATCH i conci*.csv, conci = 0.01, 0.1, 1, 10
    % 'BATCH i conci analytei.csv, analytei = blank,adenosine,lactate,
    %     glucose, glutamate, dopamine, creatinine, uric acid, urea
    % 'BATCH i conci analytei samplei.csv, samplei = 1,..5 (missing for blank)

    % deal with blanks
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
    
    for J = 1:4 % each concentration
        switch J
            case 1
                spectra = [spectra; blankD01'];
                analyteArr = [analyteArr 0.0];
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.2f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), ...
                        K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.01];
                end

            case 2
                spectra = [spectra; blankD1'];
                analyteArr = [analyteArr; 0.0];
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.1f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), ...
                        K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 0.1];
                end

            case 3
                spectra = [spectra; blank1'];
                analyteArr = [analyteArr; 0.0];
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.0f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), ...
                        K);
                    newSpectrum = addOneSpectrum(dir_to_search, filename);
                    spectra = [spectra; newSpectrum];
                    analyteArr = [analyteArr; 1];
                end

            case 4
                spectra = [spectra; blank10'];
                analyteArr = [analyteArr; 0.0];
                for K = Kstart:Kend % each sample
                    filename = sprintf(...
                        'Batch %s %0.0f-*%s %d.csv', ...
                        batchNames(batchChoice), conc(J), ...
                        analyteNames(analyteChoice), ...
                        K);
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
    else
        denominator1 = 1;
    end
    normalized = f/denominator1;
    % one more time to account for fact that > 1 point under
    % curve is used
    b = normalized/max(normalized);
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