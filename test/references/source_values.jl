using Test
using MOProblems

# Objective values compared with values computed independently from each
# family's source, not from this package. Each point is inside the problem's
# bounds or recommended box.

@testset "Reference values from the sources" begin
    # Amaral, Assunção & Souza (2025), Examples AAS1 and AAS2.
    @testset "AAS" begin
        @test eval_f(AAS1(), [0.3, -1.45]) ≈
              [1.795625, 2.254120138609] rtol = 1e-12
        @test eval_f(AAS2(), [0.3, -1.45]) ≈
              [2.9450153740351, 3.4787241129528] rtol = 1e-12
    end

    # Ansary & Panda (2014), Examples 1-4.
    @testset "AP" begin
        @test eval_f(AP1(), [0.3, -1.4]) ≈
              [66.876825, 2.6269498103805, 1.4752030257285] rtol = 1e-12
        @test eval_f(AP2(), [2.5]) ≈
              [2.25, 2.25] rtol = 1e-12
        @test eval_f(AP3(), [-0.7, 1.6]) ≈
              [2.100825, 4.1221] rtol = 1e-12
        @test eval_f(AP4(), [0.3, -1.4, 2.2]) ≈
              [29.859566666667, 8.3329168666553, 1.5646386670426] rtol = 1e-12
    end

    # Binh & Korn (1996), Application 1.
    @testset "BK" begin
        @test eval_f(BK1(), [1.5, -2.5]) ≈
              [8.5, 68.5] rtol = 1e-12
    end

    # Das & Dennis (1998), Section 10.
    @testset "DD" begin
        @test eval_f(DD1(), [0.4, -1.3, 2.1, 0.7, -0.9]) ≈
              [7.56, -2.05904] rtol = 1e-12
    end

    # Dumitrescu, Grosan & Oltean (2000), Examples 1-3.
    @testset "DGO" begin
        @test eval_f(DGO0(), [1.3]) ≈
              [1.69, 0.49] rtol = 1e-12
        @test eval_f(DGO1(), [2.6]) ≈
              [0.51550137182146, -0.15774569414325] rtol = 1e-12
        @test eval_f(DGO2(), [-4.5]) ≈
              [20.25, 1.2057713659401] rtol = 1e-12
    end

    # Deb et al. (2005), Eqs. (6.18)-(6.22).
    @testset "DTLZ" begin
        @test eval_f(DTLZ1(k = 3, nobj = 4), [0.6, 0.35, 0.7, 0.2, 0.9, 0.45]) ≈
              [16.629375, 7.126875, 44.11875, 45.25] rtol = 1e-12
        @test eval_f(DTLZ2(k = 3, nobj = 4), [0.6, 0.35, 0.7, 0.2, 0.9, 0.45]) ≈
              [
                  0.28497644948251, 0.55929777357594, 0.38466398073173, 1.0132937854546,
              ] rtol = 1e-12
        @test eval_f(DTLZ3(k = 3, nobj = 4), [0.6, 0.35, 0.7, 0.2, 0.9, 0.45]) ≈
              [
                  51.477781792749, 101.03083534655, 69.485210092259, 183.04009497733,
              ] rtol = 1e-12
        @test eval_f(DTLZ4(k = 3, nobj = 4, alpha = 2.0), [
            0.6, 0.35, 0.7, 0.2, 0.9, 0.45,
        ]) ≈
              [
                  0.74541721445916, 0.72235953474773, 0.20223740091445, 0.67112306071119,
              ] rtol = 1e-12
        @test eval_f(DTLZ4(k = 3, nobj = 4), [0.99, 0.995, 0.98, 0.2, 0.9, 0.45]) ≈
              [
                  0.59690595246674, 0.12617695599438, 0.85593425031841, 0.68111340378649,
              ] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "FA" begin
        @test eval_f(FA1(), [0.3, 0.8, 0.15]) ≈
              [0.71184365950044, 0.66804656142543, 0.053858757590603] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI (the corrected transcription the constructor
    # follows).
    @testset "Far" begin
        @test eval_f(Far1(), [0.35, -0.55]) ≈
              [0.26415134971377, -0.40615899634631] rtol = 1e-12
    end

    # Fliege, Graña Drummond & Svaiter (2009), Eqs. (8.2)-(8.4).
    @testset "FDS" begin
        @test eval_f(FDS(nvar = 4), [0.3, -1.8, 1.15, 0.55]) ≈
              [63.692865234375, 6.006271096376, 2.17343887635] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "FF" begin
        @test eval_f(FF1(), [0.3, -0.6]) ≈
              [0.47795422323898, 0.985735766091] rtol = 1e-12
    end

    # Hillermeier (2001), Example 4.1, Eq. (35).
    @testset "Hil" begin
        @test eval_f(Hil1(), [0.3, 0.65]) ≈
              [0.38625143067965, 0.75210751467201] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "IKK" begin
        @test eval_f(IKK1(), [12.5, -7.0]) ≈
              [156.25, 56.25, 49.0] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "IM" begin
        @test eval_f(IM1(), [2.3, 1.4]) ≈
              [3.0331501776206, 4.08] rtol = 1e-12
    end

    # Jin, Olhofer & Sendhoff (2001), F1 and F4, Eqs. (9)-(10) and (17)-(19).
    @testset "JOS" begin
        @test eval_f(JOS1(nvar = 4), [0.3, 0.8, 0.15, 0.55]) ≈
              [0.26375, 2.46375] rtol = 1e-12
        @test eval_f(JOS4(nvar = 4), [0.3, 0.8, 0.15, 0.55]) ≈
              [0.3, 2.8419675078025] rtol = 1e-12
    end

    # Kim & de Weck (2005), Example 2, Eq. (14); maximized there, so negated here.
    @testset "KW" begin
        @test eval_f(KW2(), [0.4, -0.7]) ≈
              [0.075616177975568, -1.1199531460741] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "LE" begin
        @test eval_f(LE1(), [1.3, -2.2]) ≈
              [1.2643407851746, 1.6781017752406] rtol = 1e-12
    end

    # Lovison (2011), Eqs. (4.1)-(4.6); Examples 1-5 are maximized there, so negated here.
    @testset "Lov" begin
        @test eval_f(Lov1(), [1.3, -2.2]) ≈
              [6.5177, 25.6138] rtol = 1e-12
        @test eval_f(Lov2(), [0.3, -0.45]) ≈
              [-0.45, 0.36692307692308] rtol = 1e-12
        @test eval_f(Lov3(), [1.3, -2.2]) ≈
              [6.53, 18.48] rtol = 1e-12
        @test eval_f(Lov4(), [1.3, -0.2]) ≈
              [4.0844915295564, 22.18] rtol = 1e-12
        @test eval_f(Lov5(), [0.3, -0.45, 0.6]) ≈
              [-1.1738933916697, -0.74962932295776] rtol = 1e-12
        @test eval_f(Lov6(), [0.27, 0.1, -0.05, 0.12, -0.15, 0.03]) ≈
              [0.27, 0.3122501692481] rtol = 1e-12
    end

    # Mita, Fukuda & Yamashita (2019), Appendix A, problems 13-16; the Gaussian objectives
    # are residuals, not squares.
    @testset "MGH" begin
        @test eval_f(MGH9(), [0.4, 1.1, 0.3]) ≈
              [
                  0.00053256213961822, 0.0028569856805887, 0.010423386041757,
                  0.027611040014012, 0.051675205110623, 0.063504511808946,
                  0.039196094020484, -0.018217936745415, -0.070787951209464,
                  -0.084099585378311, -0.062179516789754, -0.03219881018211,
                  -0.012137316262299, -0.0033980335219051, -0.00075780208908453,
              ] rtol = 1e-12
        @test eval_f(MGH16(nobj = 5), [1.3, -2.2, 0.4, 0.6]) ≈
              [
                  0.34300848281015, 1.231412684031, 3.4008925999062, 7.2300076258009,
                  13.22488217438,
              ] rtol = 1e-12
        @test eval_f(MGH26(nvar = 4), [0.3, -0.8, 0.15, 0.55]) ≈
              [
                  0.065435945159308, 3.3511105425404, 0.15281049929515, 0.32933353065341,
              ] rtol = 1e-12
        @test eval_f(MGH33(nvar = 10, nobj = 4), [
            0.3, -0.8, 0.15, 0.55, -0.2, 0.7, -0.45, 0.05, 0.9, -0.6,
        ]) ≈
              [8.41, 46.24, 114.49, 213.16] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "MHHM" begin
        @test eval_f(MHHM1(), [0.37]) ≈
              [0.1849, 0.2304, 0.2809] rtol = 1e-12
        @test eval_f(MHHM2(), [0.37, 0.81]) ≈
              [0.229, 0.2425, 0.325] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI; MLF2 is maximized there, so negated here.
    @testset "MLF" begin
        @test eval_f(MLF1(), [7.3]) ≈
              [1.160845987158, 0.71809581122521] rtol = 1e-12
        @test eval_f(MLF2(), [1.7, -2.4]) ≈
              [-4.4466415, -3.020544] rtol = 1e-12
    end

    # Miglierina, Molho & Recchioni (2008), Tests 1-4, Eqs. (55)-(56), (60), (65).
    @testset "MMR" begin
        @test eval_f(MMR1(), [0.45, 0.23]) ≈
              [0.45, 2.4226737723603] rtol = 1e-12
        @test eval_f(MMR2(), [0.35, 0.62]) ≈
              [0.35, 6.9772612728087] rtol = 1e-12
        @test eval_f(MMR3(), [0.3, -0.45]) ≈
              [0.027, -0.421875] rtol = 1e-12
        @test eval_f(MMR4(), [1.3, 2.2, 0.7]) ≈
              [-8.8, -2.4] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "QV" begin
        @test eval_f(QV1(nvar = 4), [0.3, -1.8, 2.15, 0.55]) ≈
              [1.8978030213561, 1.8805110463146] rtol = 1e-12
    end

    # Mita, Fukuda & Yamashita (2019), Appendix A, problem 5.
    @testset "SD" begin
        @test eval_f(SD(), [1.5, 2.0, 1.8, 2.5]) ≈
              [10.874011537018, 5.1188952983432] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI; maximized there, so negated here.
    @testset "SK" begin
        @test eval_f(SK1(), [1.3]) ≈
              [-30.4529, -11.86595] rtol = 1e-12
        @test eval_f(SK2(), [1.3, -2.2, 0.4, 3.1]) ≈
              [18.1, -0.50392157036934] rtol = 1e-12
    end

    # Schütze et al. (2008), Eqs. (17) and (18).
    @testset "SLCDT" begin
        @test eval_f(SLCDT1(), [0.3, -0.45]) ≈
              [1.9899091114252, 1.2399091114252] rtol = 1e-12
        @test eval_f(SLCDT1(lambda = 0.0), [0.3, -0.45]) ≈
              [1.5055937104039, 0.75559371040392] rtol = 1e-12
        @test eval_f(SLCDT2(), [0.3, -0.8, 0.15, 0.55, -0.2, 0.7, -0.45, 0.05, 0.9, -0.6]) ≈
              [11.5101, 14.1216, 11.15950625] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "SP" begin
        @test eval_f(SP1(), [1.3, -2.2]) ≈
              [12.34, 39.29] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "SSFYY" begin
        @test eval_f(SSFYY2(), [2.7]) ≈
              [21.829904997395, 1.69] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "TKLY" begin
        @test eval_f(TKLY1(), [0.45, 0.12, 0.8, 0.33]) ≈
              [0.45, 10.421017222809] rtol = 1e-12
    end

    # Mita, Fukuda & Yamashita (2019), Appendix A, problems 8-11.
    @testset "Toi" begin
        @test eval_f(Toi4(), [0.3, -0.8, 1.15, 0.55]) ≈
              [1.73, 1.785] rtol = 1e-12
        @test eval_f(Toi8(nvar = 3), [0.3, -0.8, 0.15]) ≈
              [0.16, 3.92, 9.1875] rtol = 1e-12
        @test eval_f(Toi9(nvar = 4), [0.3, -0.8, 0.15, 0.55]) ≈
              [0.8, 5.11, 7.975, 0.1825] rtol = 1e-12
        @test eval_f(Toi10(nvar = 4), [0.3, -0.8, 0.15, 0.55]) ≈
              [82.45, 24.7325, 28.028125] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "VU" begin
        @test eval_f(VU1(), [1.3, -2.2]) ≈
              [0.132802124834, 17.21] rtol = 1e-12
        @test eval_f(VU2(), [1.3, -2.2]) ≈
              [0.1, -3.71] rtol = 1e-12
    end

    # Huband et al. (2006), Table VIII; MOP3 is maximized there, so negated here.
    @testset "VV" begin
        @test eval_f(MOP2(nvar = 4), [0.3, -0.2, 0.6, 0.1]) ≈
              [0.50341469620859, 0.8997411562772] rtol = 1e-12
        @test eval_f(MOP3(), [1.3, -2.2]) ≈
              [10.099151742457, 19.93] rtol = 1e-12
        @test eval_f(MOP5(), [1.3, -2.2]) ≈
              [3.5093164256785, 34.66125, 0.13119721839923] rtol = 1e-12
        @test eval_f(MOP6(), [0.35, 0.62]) ≈
              [0.35, 6.9772612728087] rtol = 1e-12
        @test eval_f(MOP7(), [13.5, -27.0]) ≈
              [121.125, 175.84375, 264.85613445378] rtol = 1e-12
    end

    # Zitzler, Deb & Thiele (2000), Eqs. (7)-(12).
    @testset "ZDT" begin
        @test eval_f(ZDT1(nvar = 4), [0.3, 0.8, 0.15, 0.55]) ≈
              [0.3, 4.2154767421335] rtol = 1e-12
        @test eval_f(ZDT2(nvar = 4), [0.3, 0.8, 0.15, 0.55]) ≈
              [0.3, 5.4836363636364] rtol = 1e-12
        @test eval_f(ZDT3(nvar = 4), [0.35, 0.8, 0.15, 0.55]) ≈
              [0.35, 4.4625563074488] rtol = 1e-12
        @test eval_f(ZDT4(nvar = 4), [0.3, -1.2, 2.5, 0.7]) ≈
              [0.3, 41.671423791103] rtol = 1e-12
        @test eval_f(ZDT6(nvar = 4), [0.3, 0.8, 0.15, 0.55]) ≈
              [0.98757893788823, 8.4542366859349] rtol = 1e-12
    end

    # Huband et al. (2006), Table XVI.
    @testset "ZLT" begin
        @test eval_f(ZLT1(nvar = 4, nobj = 3), [0.3, -1.8, 2.15, 0.55]) ≈
              [8.655, 12.855, 4.955] rtol = 1e-12
    end
end
