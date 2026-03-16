%
% function [freq, S, freqN, N] = loadSnP(FileName);
%
% Imports data from a Touchstone file (SnP-file). S-parameters
% are always received as (linear) complex numbers. The reference
% impedance is always 50 ohms. The unit of the frequency is Hertz.
% The S-parameter matrix contains one S-parameter within every
% column, S11, S12, ..., S21, S22, ... . They are normalized to
% 50 ohms. The noise parameter matrix N contains (if present) the
% following columns in every row: minimum noise figure in decibel,
% optimum source reflexion coefficient normalized to 50 ohms,
% normalized effective noise impedance (normalized to 50 ohms).
%
% Attention: Touchstone files may contain Z-, Y- oder H-parameters
%    This option is not supported! Only a warning is displayed.
% 
% Parameters:   FileName  - name of the SnP-file
%               freq      - frequency of the S-parameters
%               S         - S-parameter matrix
%               freqN     - frequency of the noise parameters
%               N         - noise data
%
% Copyright 2014 by Michael Margraf
% This is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License (GPL v2).
% NO WARRANTY AT ALL!
%

function [freq, S, freqN, N] = loadSnP(FileName);

if nargin ~= 1
    error("Exactly one input parameter has to be delivered!");
end
if ~ischar(FileName)
    error("Input parameter has to be a character string!");
end

freq  = [];  % Frequenz der S-Parameter
S     = [];  % S-Parameter
freqN = [];  % Frequenz der Rauschparameter
N     = [];  % Rauschparameter
Sn    = [];  % Anzahl der S-Parameter pro Zeile

% Inhalt der Datei als "cellstrings" einlesen
Inhalt = textread(FileName, "%s", "delimiter", "\n");

% *************************************************************************
% Kommentare (eingeleitet durch "!") entfernen
for n=1:length(Inhalt)     % jede Zeile einzeln durchgehen
    s = char(Inhalt(n));
    if isempty(s)
        continue
    end
    i = find(s == '!');    % Kommentare suchen
    if ~isempty(i)
       if i(1) == 1        % gesamte Zeile ist Kommentar ?
          Inhalt(n) = cellstr('');
       else
          Inhalt(n) = cellstr(s(1:i-1));       % Kommentar entfernen
       end
    end
end

% *************************************************************************
% S-Parameter extrahieren
r = [];         % Zwischenspeicher für S-Parameter-Satz löschen
Rauschen = 0;   % Zeichen für keine Rauschparameter
FreqExp = 1e9; Format = "MA"; Z0 = 50;   % Default-Werte der Options-Zeile

for n=1:length(Inhalt)     % jede Zeile einzeln durchgehen
    s = char(Inhalt(n));
    if isempty(s) continue; end % wenn Zeile leer, dann weiter mit Schleife
    
    if s(1) == '#'         % Options-Zeile ?
       [FreqExp, Format, Z0] = Option_Line(s);
       continue;
    end
    
    s = str2num(char(s));         % in Zahlen umwandeln
    if isempty(s) continue; end   % sind Zahlen in der Zeile ?
       
    if isempty(Sn)   % die ersten S-Parameter ?
        Sn = (length(s) - 1)/2;      % Tor-Anzahl der S-Parameter-Sätze
        if ((mod(Sn, 1)~=0) || (Sn==2)) % 2 Zahlen pro S-Parameter und 2-Tor-Parameter liegen in einer Zeile
            error(sprintf("Wrong number of S-parameters in line %i!",n));
        end
        freq(1) = s(1)*FreqExp;
        a = 2;
    elseif isempty(r)    % neuer S-Parameter-Satz (neue Frequenz) ?
        if (s(1)*FreqExp) <= freq(length(freq))
            Rauschen = 1; % Zeichen für Rauschparameter
            break     % abbrechen, wenn Rausch-Daten beginnen
        end
        if ((length(s)~=(2*Sn+1)) && ((Sn~=2) || (length(s)~=9)))
            error(sprintf("Wrong number S-parameters in line %i!",n));
        end
        freq(length(freq)+1) = s(1)*FreqExp;
        a = 2;
    else     % voriger S-Parameter-Satz weiter
        if length(s) ~= 2*Sn
            if ~((Sn==4) & (length(s)==9) & isempty(S))    % liegt 2-Tor-Ausnahme vor ?
                error(sprintf("Wrong number S-parameters in line %i!",n));
            end
            S(1,:) = Formatieren(r, Format, Z0);   % voriger Satz war vollständig
            freq(length(freq)+1) = s(1)*FreqExp;
            r  = [];
            Sn = 2;     % Tor-Anzahl korrigieren
            a  = 2;
        else
            a = 1;
        end
    end

    r = [r s(a:length(s))];
    if length(r)==2*(Sn^2)    % S-Parameter-Satz vollständig ?
        S(length(freq),:) = Formatieren(r, Format, Z0);
        r = [];
    end
end

if Sn == 2
    S = [S(:,1) S(:,3) S(:,2) S(:,4)];  % bei 2-Tor-Parametern S12 und S21 umdrehen
end
if ~Rauschen  return; end   % sind Rausch-Parameter vorhanden ?
% *************************************************************************
% Rauschparameter extrahieren

for n=n:length(Inhalt)
    s = char(Inhalt(n));
    if isempty(s) continue; end
    
    if s(1) == '#'         % Options-Zeile ?
       [FreqExp, Format, Z0] = Option_Line(s);
    else
       s = str2num(char(s));    % in Zahlen umwandeln
       if isempty(s)            % leere Zeile ?
          continue
       end
       if length(s)~=5
           error(sprintf("Wrong number of noise parameters in line %i!",n));
       end
       r = Formatieren(s(3:4), "MA", Z0); % opt. Quellenreflexionsfaktor (immer linear!)
       s(5) = s(5)*Z0/50;       % auf 50 Ohm normieren
       
       N(length(freqN)+1,:)   = [s(2) r s(5)];
       freqN(length(freqN)+1) = s(1)*FreqExp;
    end
end
% ****  ENDE  ****

% ************************************************************************
% Diese Funktion wertet die Optionszeile aus und gibt die darin enthaltenen
% Parameter zurück.
function [FreqExp, Format, Z0] = Option_Line(s);

s(1) = ' ';      % "#" löschen
weiter = 0;
FreqExp = 1e9;   % Default-Wert des Frequenz-Exponenten (falls keine Angabe)
Format  = "MA";  % Default-Wert des Parameter-Types (falls keine Angabe)
Z0      = 50;    % Default-Wert der Referenz-Impedanz (falls keine Angabe)

[t, s] = strtok(s); % erstes Token holen
switch upper(t)     % Frequenz-Exponenten auswerten
case  "HZ"; FreqExp = 1;
case "KHZ"; FreqExp = 1e3;
case "MHZ"; FreqExp = 1e6;
case "GHZ"; FreqExp = 1e9;
otherwise
    weiter = 1;   % falls Angabe nicht vorhanden
end

if weiter ~= 1
    [t, s] = strtok(s);     % nächstes Token holen
end
weiter = 0;
switch upper(t)     % Parameter-Typen auswerten
case {'Y','Z','G','H'}; warning("File contains no S-parameters!");
case 'S' ;
otherwise
    weiter = 1;   % falls Angabe nicht vorhanden
end

if weiter ~= 1
    [t, s] = strtok(s);     % nächstes Token holen
end
weiter = 0;
switch upper(t)     % Parameter-Format auswerten
case {"MA","DB","RI"}; Format = upper(t);
otherwise
    weiter = 1;   % falls Angabe nicht vorhanden
end

if weiter ~= 1
    [t, s] = strtok(s);     % nächstes Token holen
end
weiter = 0;
if isempty(deblank(t))      % Ende der Zeile ?
    return
end
if upper(t) ~= 'R'          % Angabe der Referenz-Impedanz ?
    error("Unknown file format: Fault in option line!");
end

[t, s] = strtok(s);
if isempty(deblank(t))
    error("Impedance in option line missing!");
end
Z0 = str2num(t);
if Z0 <= 0      % Referenz-Impedanz muß positiv sein
    error("Invalid file format: Invalid impedance in option line!");
end
if ~isempty(deblank(s))
    error("Invalid file format: Wrong parameter in option line!");
end

% ************************************************************************
% Rechnet die S-Parameter je nach Formatangabe in komplexe Zahl um.
function SZ0 = Formatieren(s, Format, Z0);

r = [];
switch Format
case "MA"    % Betrag und Winkel in Grad
     for n=1:2:length(s)
         r((n+1)/2) = s(n) * exp(j*s(n+1)*pi/180);
     end
case "DB"    % Betrag in dB und Winkel in Grad
     for n=1:2:length(s)
         r((n+1)/2) = 10^(s(n)/20) * exp(j*s(n+1)*pi/180);
     end
case "RI"    % Real- und Imaginärteil
     for n=1:2:length(s)
         r((n+1)/2) = s(n)+j*s(n+1);
     end
end

if Z0 ~= 50   % falls Referenz-Impedanz nicht 50 Ohm => umnormieren
    switch length(r)
    case 1    % 1-Tor, dann nur ein Reflexionsfaktor umnormieren
        SZ0 = (Z0*(1+r) - 50*(1-r)) ./ (Z0*(1+r) + 50*(1-r));
    case 4    % 2-Tor, Umnormierung schon deutlich komplizierter
        x = (50-Z0) / (50+Z0);  % formaler Reflexionsfaktor
        f = (1-x*r(1))*(1-x*r(4))-x*x*r(2)*r(3);
    
        SZ0(1) = ( (r(1)-x)*(1-x*r(4))+x*r(2)*r(3) ) / f;
        SZ0(2) = r(2)*(1-x*x) / f;
        SZ0(3) = r(3)*(1-x*x) / f;
        SZ0(4) = ( (r(4)-x)*(1-x*r(1))+x*r(2)*r(3) ) / f;
    otherwise % n-Tor mit n > 2
        q = sqrt(length(r));
        x = (50-Z0) / (50+Z0); % formaler Reflexionsfaktor
        for w=0:length(r)-1    % quadratische S-Parameter-Matrix erstellen
            S(floor(w/q)+1 , mod(w,q)+1) = r(w+1);
        end

        S = (S-x*eye(q)) * inv(eye(q)-x*S);   % S-Parameter umnormieren
        
        for w=0:q-1 % in übliche Matrixform (nicht quadratisch) schreiben
            SZ0(w*q+1:w*q+q) = S(w+1,:);
        end
    end
else
    SZ0 = r;
end
