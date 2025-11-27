% ...existing code...
function rts = quadratic_function(coefficients)
    % Function to solve polynomial equations using roots() function
    % Input: coefficients - array of polynomial coefficients in descending order
    % Output: rts - array containing the roots of the polynomial

    % Error checking for input
    if nargin < 1 || isempty(coefficients)
        error('Coefficient array cannot be empty');
    end
    
    % Remove leading zeros
    while length(coefficients) > 1 && coefficients(1) == 0
        coefficients = coefficients(2:end);
    end
    
    % Calculate roots using MATLAB's roots() function (no name conflict)
    rts = roots(coefficients);
    
    % Round very small imaginary parts to zero
    idx = abs(imag(rts)) < 1e-10;
    rts(idx) = real(rts(idx));
end
% ...existing code...
% Example usage (commented out so file remains a pure function):
coeffs = [ 3.45 -0.65 -0.05 0.0105 ];  
r = quadratic_function(coeffs);
% ...existing code...


