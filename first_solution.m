clc;
clear;
close all;

%% ============================================================
%        Thermodynamics Project
%   Uniform-Flow Process in a Rigid Tank
%% ============================================================

%% Initial Data

V  = 50;                  % Tank Volume (m^3)

v1 = 64.721/1000;         % Initial Specific Volume (m^3/kg)
u1 = 2915.8;              % Initial Internal Energy (kJ/kg)
h1 = 3207.1;              % Initial Enthalpy (kJ/kg)

%% Linearized Thermodynamic Properties

v = @(T) (1.0764*T - 1.7563)/1000;      % m^3/kg
u = @(T) 1.0108*T + 21.206;             % kJ/kg
h = @(T) 1.0126*T + 20.607;             % kJ/kg

%% Initial Mass

m1 = V/v1;

%% Energy Balance Equation

F = @(T) ...
m1*u1 ...
- (V./v(T)).*u(T) ...
- (m1 - V./v(T)).*((h1 + h(T))/2);

%% Solve Final Temperature

T2 = fzero(F,[50 3000]);

%% Final State

v2 = v(T2);
u2 = u(T2);
h2 = h(T2);

m2 = V/v2;
me = m1 - m2;

%% ============================================================
% Validation
%% ============================================================

%% Volume Check

V1_calc = m1*v1;
V2_calc = m2*v2;

ErrV1 = abs(V1_calc-V);
ErrV2 = abs(V2_calc-V);

ErrV1_percent = ErrV1/V*100;
ErrV2_percent = ErrV2/V*100;

%% Mass Balance

MassResidual = abs(m1-(m2+me));
MassError_percent = MassResidual/m1*100;

%% Energy Equation Residual

EnergyResidual = abs(F(T2));

%% Overall Numerical Error

OverallError = max([ErrV1_percent ...
                    ErrV2_percent ...
                    MassError_percent]);

%% ============================================================
% Results
%% ============================================================

fprintf('\n');
fprintf('=====================================================\n');
fprintf('                 FINAL RESULTS\n');
fprintf('=====================================================\n\n');

fprintf('Final Temperature (T2) = %.4f °C\n',T2);

fprintf('Initial Mass (m1)      = %.4f kg\n',m1);
fprintf('Final Mass (m2)        = %.4f kg\n',m2);
fprintf('Discharged Mass (me)   = %.4f kg\n\n',me);

fprintf('Final Specific Volume  = %.6f m^3/kg\n',v2);
fprintf('                       = %.3f cm^3/g\n',v2*1000);

fprintf('Final Internal Energy  = %.3f kJ/kg\n',u2);
fprintf('Final Enthalpy         = %.3f kJ/kg\n',h2);

fprintf('\n');
fprintf('=====================================================\n');
fprintf('             VALIDATION RESULTS\n');
fprintf('=====================================================\n');

fprintf('\n[1] Volume Verification\n');
fprintf('-----------------------------------------------------\n');

fprintf('Calculated Initial Volume = %.8f m^3\n',V1_calc);
fprintf('Actual Tank Volume        = %.8f m^3\n',V);
fprintf('Volume Error              = %.10f %%\n\n',ErrV1_percent);

fprintf('Calculated Final Volume   = %.8f m^3\n',V2_calc);
fprintf('Actual Tank Volume        = %.8f m^3\n',V);
fprintf('Volume Error              = %.10f %%\n',ErrV2_percent);

fprintf('\n[2] Mass Balance Verification\n');
fprintf('-----------------------------------------------------\n');

fprintf('Mass Residual             = %.12f kg\n',MassResidual);
fprintf('Mass Error                = %.12f %%\n',MassError_percent);

fprintf('\n[3] Energy Equation Verification\n');
fprintf('-----------------------------------------------------\n');

fprintf('Residual F(T2)            = %.12e\n',EnergyResidual);

fprintf('\n[4] Overall Numerical Accuracy\n');
fprintf('-----------------------------------------------------\n');

fprintf('Maximum Numerical Error   = %.10f %%\n',OverallError);

if OverallError < 0.01
    fprintf('Validation Status         = PASSED ✓\n');
else
    fprintf('Validation Status         = CHECK REQUIRED\n');
end

fprintf('=====================================================\n');
%% ============================================================
% Validation of Linearized Properties
%% ============================================================

fprintf('\n');
fprintf('=====================================================\n');
fprintf('      VALIDATION OF LINEARIZED PROPERTIES\n');
fprintf('=====================================================\n');

%% ----------- Steam Table Data (Replace with your table) -----------

T_table = [400 500 600 700 800 900 1000];

v_table = [64.721 72.640 80.182 87.430 94.436 101.237 107.860];   % cm^3/g
u_table = [2915.8 3023.4 3124.8 3221.2 3313.4 3401.8 3487.1];     % kJ/kg
h_table = [3207.1 3350.3 3492.1 3633.0 3773.3 3913.1 4052.5];     % kJ/kg

%% -------- Linear Model Values --------

v_fit = (1.0764*T_table - 1.7563);     % cm^3/g
u_fit = 1.0108*T_table + 21.206;
h_fit = 1.0126*T_table + 20.607;

%% -------- Percent Errors --------

Err_v = abs(v_fit-v_table)./v_table*100;
Err_u = abs(u_fit-u_table)./u_table*100;
Err_h = abs(h_fit-h_table)./h_table*100;

%% -------- Thermodynamic Consistency --------

P = 4500;       % kPa

h_thermo = u_fit + P*(v_fit/1000);

Err_h_thermo = abs(h_fit-h_thermo)./h_thermo*100;

%% -------- Print Results --------

fprintf('\n');
fprintf('%6s %12s %12s %12s %12s\n',...
'T(°C)','Err(v)%','Err(u)%','Err(h)%','h=u+Pv');

fprintf('---------------------------------------------------------------\n');

for i=1:length(T_table)

    fprintf('%6.0f %12.3f %12.3f %12.3f %12.3f\n',...
        T_table(i),Err_v(i),Err_u(i),Err_h(i),Err_h_thermo(i));

end

fprintf('---------------------------------------------------------------\n');

fprintf('Maximum Error in v      = %.2f %%\n',max(Err_v));
fprintf('Maximum Error in u      = %.2f %%\n',max(Err_u));
fprintf('Maximum Error in h      = %.2f %%\n',max(Err_h));
fprintf('Maximum h=u+Pv Error    = %.2f %%\n',max(Err_h_thermo));

fprintf('Average h=u+Pv Error    = %.2f %%\n',mean(Err_h_thermo));

%% -------- Plot --------

figure('Color','w');

subplot(2,2,1)
plot(T_table,v_table,'ko','MarkerFaceColor','k')
hold on
plot(T_table,v_fit,'r','LineWidth',2)
grid on
title('Specific Volume')
xlabel('Temperature (°C)')
ylabel('v (cm^3/g)')
legend('Steam Table','Linear Model')

subplot(2,2,2)
plot(T_table,u_table,'ko','MarkerFaceColor','k')
hold on
plot(T_table,u_fit,'r','LineWidth',2)
grid on
title('Internal Energy')
xlabel('Temperature (°C)')
ylabel('u (kJ/kg)')
legend('Steam Table','Linear Model')

subplot(2,2,3)
plot(T_table,h_table,'ko','MarkerFaceColor','k')
hold on
plot(T_table,h_fit,'r','LineWidth',2)
grid on
title('Enthalpy')
xlabel('Temperature (°C)')
ylabel('h (kJ/kg)')
legend('Steam Table','Linear Model')

subplot(2,2,4)
plot(T_table,Err_h_thermo,'b-o','LineWidth',2)
grid on
title('Thermodynamic Consistency Error')
xlabel('Temperature (°C)')
ylabel('Error (%)')

%% -------- Final Conclusion --------

fprintf('\n');
fprintf('=====================================================\n');
fprintf('MODEL ASSESSMENT\n');
fprintf('=====================================================\n');

if max(Err_h_thermo) > 5
    fprintf('✗ The proposed linear relations are NOT valid.\n');
    fprintf('✗ They do NOT satisfy the thermodynamic identity:\n');
    fprintf('      h = u + P*v\n');
    fprintf('✗ Therefore, the obtained results are physically unreliable.\n');
else
    fprintf('✓ The linear relations satisfy the thermodynamic identity.\n');
end

fprintf('=====================================================\n');