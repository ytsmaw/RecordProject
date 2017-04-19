function [curve_record, curve_playback, dB_playback, dB_record] = RIAA(fq)

    %equation from http://www.bonavolta.ch/hobby/en/audio/riaa.htm

    t1 = 75e-6;
    t2 = 318e-6;
    t3 = 3180e-6;
    offset = 32.4583;
    meds = 10*log10(1 + (4*pi^2.*fq.^2*t2^2).^-1);
    trebs = 10*log10(1 + (4*pi^2.*fq.^2*t1^2).^-1);
    bass = 10*log10(1 + 4* pi^2.*fq.^2*t3^2);
    
    dB_playback = meds - trebs - bass + offset;
    
    curve_playback = 10.^(dB_playback./20);
    
    curve_record = curve_playback.^-1;
    
    dB_record = 20.*log10(curve_record);
        
end
    