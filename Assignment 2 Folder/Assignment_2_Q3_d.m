%% Check eigenvalues vs poles for G(z)

% G(z) = (2 z^-1 + 13 z^-2 - 7 z^-3) / (1 + 7 z^-1 - 24 z^-2 - 180 z^-3)

num = [2 13 -7];          % numerator coefficients
den = [1 7 -24 -180];     % denominator coefficients

%% 1. Poles of G(z) from the denominator
poles = roots(den);       % poles in the z-plane
disp('Poles of G(z) from roots(den):');
disp(poles);

%% 2. Controllable canonical form (Ac)
Ac = [  0   1   0;
        0   0   1;
      180  24  -7 ];

Bc = [0; 0; 1];
Cc = [-7 13 2];
Dc = 0;

eig_Ac = eig(Ac);
disp('Eigenvalues of controllable A_c:');
disp(eig_Ac);

%% 3. Observable canonical form (Ao)
Ao = [ 0   0   180;
       1   0    24;
       0   1    -7 ];

Bo = [-7; 13; 2];
Co = [0 0 1];
Do = 0;

eig_Ao = eig(Ao);
disp('Eigenvalues of observable A_o:');
disp(eig_Ao);

%% 4. Modal canonical form (Aw) via eigen-decomposition
[V, Lambda] = eig(Ac);    % you could also use Ao here, result is the same
Aw = Lambda;              % modal A matrix (diagonal / Jordan form)

eig_Aw = diag(Aw);
disp('Eigenvalues of modal A_w:');
disp(eig_Aw);

%% 5. Compare numerically (sorted)
poles_sorted  = sort(poles);
Ac_sorted     = sort(eig_Ac);
Ao_sorted     = sort(eig_Ao);
Aw_sorted     = sort(eig_Aw);

disp('Sorted poles:');
disp(poles_sorted);
disp('Sorted eig(A_c):');
disp(Ac_sorted);
disp('Sorted eig(A_o):');
disp(Ao_sorted);
disp('Sorted eig(A_w):');
disp(Aw_sorted);

disp('Differences (should be ~zero):');
disp('eig(A_c) - poles:');
disp(Ac_sorted - poles_sorted);
disp('eig(A_o) - poles:');
disp(Ao_sorted - poles_sorted);
disp('eig(A_w) - poles:');
disp(Aw_sorted - poles_sorted);
