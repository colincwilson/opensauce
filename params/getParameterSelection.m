function selection = getParameterSelection(param)
% Selection struct corresponds to the parameters you would select in
% Parameter Estimation > Parameter Selection dialog. param is optional.
% 1 = on, 0 = off

% Octave TODOs
% Straight
% 

selection = {
    'F0 (Straight)' 0;
    'F0 (Snack)' 1;
    'F0 (Praat)' 1;
    'F0 (SHR)' 1;
    'F0 (Other)' 0;
    'F1, F2, F3, F4 (Snack)' 1;
    'F1, F2, F3, F4 (Praat)' 1;
    'F1, F2, F3, F4 (Other)' 0;
    'H1, H2, H4' 1;
    'A1, A2, A3' 1;
    'H1*-H2*, H2*-H4*' 1;
    'H1*-A1*, H1*-A2*, H1*-A3*' 1;
    'Energy' 1;
    'CPP' 1;
    'Harmonic to Noise Ratios - HNR' 1;
    'Subharmonic to Harmonic Ratio - SHR' 1
    };

% user is asking for the index of a parameter
if (nargin == 1)
    selection = indexOf(param, selection);
    return;
end

    
function idx = indexOf(param, sel)
for k=1:length(sel)
    thisParam = sel{k};
    if (strcmp(thisParam, param))
        idx = k;
        return
    end
end
idx = -1;

function to_map(sel)
keys = cell(rows(sel), 1);
for k=1:length(keys)
    keys(k,1) = sel(k,1);
end

values = zeros(rows(sel), 1);
for k=1:length(values)
    values(k,1) = cell2mat(sel(k,2));
end












% -- old ---

% keys = {
%     'F0 (Straight)',
%     'F0 (Snack)',
%     'F0 (Praat)',
%     'F0 (SHR)',
%     'F0 (Other)',
%     'F1, F2, F3, F4 (Snack)',
%     'F1, F2, F3, F4 (Praat)',
%     'F1, F2, F3, F4 (Other)',
%     'H1, H2, H4',
%     'A1, A2, A3',
%     'H1*-H2*, H2*-H4*',
%     'H1*-A1*, H1*-A2*, H1*-A3*',
%     'Energy',
%     'CPP',
%     'Harmonic to Noise Ratios - HNR',
%     'Subharmonic to Harmonic Ratio - SHR',
%     };
% 
% % initialize all parameters to 'off'
% values = zeros(length(keys), 1);
% selection = containers.Map(keys, values);
% 
% % --- specify which parameters you'd like to select here -- %
% selection('F0 (Straight)') = 0;
% selection('F0 (Snack)') = 0;
% selection('F0 (Praat)') = 0;
% selection('F0 (SHR)') = 0;
% selection('F0 (Other)') = 0;
% selection('F1, F2, F3, F4 (Snack)') = 0;
% selection('F1, F2, F3, F4 (Praat)') = 0;
% selection('F1, F2, F3, F4 (Other)') = 0;
% selection('F1, F2, F3, F4 (Snack)') = 0;
% selection('H1, H2, H4') = 0;
% selection('H1*-H2*, H2*-H4*') = 0;
% selection('H1*-A1*, H1*-A2*, H1*-A3*') = 0;
% selection('A1, A2, A3') = 0;
% selection('Energy') = 0;
% selection('CPP') = 0;
% selection('Harmonic to Noise Ratios - HNR') = 0;
% selection('Subharmonic to Harmonic Ratio - SHR') = 0;
% % --- --- --- --- %
% 


% PARAMLIST
%     'F0 (Straight)'
%     'F0 (Snack)'
%     'F0 (Praat)'
%     'F0 (SHR)'
%     'F1, F2, F3, F4 (Snack)'
%     'F1, F2, F3, F4 (Praat)'
%     'A1, A2, A3'
%     'H1, H2, H4'
%     'Energy'
%     'CPP'
%     'Harmonic to Noise Ratios - HNR'
%     'Subharmonic to Harmonic Ratio - SHR'
%     'H1*-H2*, H2*-H4*'
%     'H1*-A1*, H1*-A2*, H1*-A3*'
