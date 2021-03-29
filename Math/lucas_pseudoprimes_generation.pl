#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# Date: 07 October 2018
# Edit: 19 August 2020
# https://github.com/trizen

# A new algorithm for generating super-Lucas pseudoprimes.

# See also:
#   https://oeis.org/A217120 -- Lucas pseudoprimes
#   https://oeis.org/A217255 -- Strong Lucas pseudoprimes
#   https://oeis.org/A177745 -- Semiprimes n such that n divides Fibonacci(n+1).
#   https://oeis.org/A212423 -- Frobenius pseudoprimes == 2,3 (mod 5) with respect to Fibonacci polynomial x^2 - x - 1.

# See also:
#   https://trizenx.blogspot.com/2020/08/pseudoprimes-construction-methods-and.html

use 5.020;
use warnings;
use experimental qw(signatures);

use ntheory qw(:all);
use Math::AnyNum qw(prod);

sub lucas_pseudoprimes ($limit, $callback, $P = 1, $Q = -1) {

    my %table;
    my $D = $P*$P - 4*$Q;

    forprimes {
        my $p = $_;
        foreach my $d (divisors($p - kronecker($D, $p))) {
            if ((lucas_sequence($p, $P, $Q, $d))[0] == 0) {
                push @{$table{$d}}, $p;
            }
        }
    } 3, $limit;

    foreach my $arr (values %table) {

        my $l = $#{$arr} + 1;

        foreach my $k (2 .. $l) {
            forcomb {
                my $n = prod(@{$arr}[@_]);
                $callback->($n, @{$arr}[@_]);
            } $l, $k;
        }
    }
}

sub is_weak_lucas_pseudoprime ($n, $P = 1, $Q = -1) {

    my $D = ($P*$P - 4*$Q);
    my $k = kronecker($D, $n);

    (lucas_sequence($n, $P, $Q, $n - $k))[0] == 0;
}

my @pseudoprimes;

lucas_pseudoprimes(
    10_000,
    sub ($n, @f) {

        is_weak_lucas_pseudoprime($n, 1, -1) or die "error: $n";

        push @pseudoprimes, $n;

        if (kronecker(5, $n) == -1 and powmod(2, $n-1, $n) == 1) {
            die "Found a BPSW counter-example: $n = prod(@f)";
        }
    }
);

@pseudoprimes = sort { $a <=> $b } @pseudoprimes;

say join(', ', @pseudoprimes);

__END__
323, 377, 1891, 3827, 4181, 4181, 5777, 5777, 8149, 10877, 10877, 11663, 13201, 15251, 17711, 18407, 19043, 23407, 25877, 27323, 34943, 39203, 40501, 51841, 51983, 53663, 60377, 64079, 64681, 67861, 68251, 75077, 75077, 78409, 86063, 88601, 88831, 88831, 90061, 90061, 94667, 96049, 97921, 97921, 100127, 113573, 113573, 115231, 118441, 121103, 121393, 145351, 146611, 153781, 161027, 162133, 162133, 182513, 191351, 195227, 197209, 200147, 218791, 218791, 219781, 231703, 250277, 250277, 254321, 272611, 294527, 302101, 302101, 303101, 303101, 306287, 330929, 330929, 330929, 345913, 381923, 429263, 430127, 433621, 438751, 453151, 453151, 454607, 456301, 500207, 507527, 520801, 520801, 530611, 548627, 556421, 569087, 572839, 600767, 607561, 629911, 635627, 636641, 636641, 636707, 638189, 642001, 685583, 697883, 721801, 722261, 736163, 741751, 753251, 753377, 775207, 828827, 851927, 853469, 873181, 948433, 954271, 983903, 999941, 999941, 1010651, 1026241, 1033997, 1033997, 1056437, 1056437, 1061341, 1081649, 1081649, 1084201, 1084201, 1084201, 1106327, 1106561, 1174889, 1197377, 1203401, 1203401, 1207361, 1256293, 1256293, 1283311, 1300207, 1314631, 1346269, 1346269, 1346269, 1346269, 1363861, 1388903, 1392169, 1392169, 1418821, 1457777, 1589531, 1626041, 1626041, 1633283, 1633283, 1657847, 1690501, 1697183, 1724213, 1735841, 1735841, 1803601, 1803601, 1950497, 1963501, 1967363, 1970299, 1970299, 2011969, 2039183, 2055377, 2071523, 2122223, 2137277, 2140921, 2140921, 2159389, 2187841, 2187841, 2214143, 2221811, 2253751, 2263127, 2290709, 2362081, 2435423, 2465101, 2465101, 2530007, 2585663, 2586229, 2586229, 2662277, 2662277, 2741311, 2757241, 2757241, 2782223, 2850077, 2872321, 2872321, 2883203, 3140047, 3166057, 3175883, 3175883, 3188011, 3196943, 3277231, 3281749, 3289301, 3338221, 3399527, 3452147, 3459761, 3470921, 3470921, 3526883, 3568661, 3604201, 3645991, 3663871, 3685207, 3768451, 3774377, 3774377, 3850907, 3939167, 3942271, 3992003, 3996991, 4023823, 4109363, 4112783, 4119301, 4119301, 4187341, 4187341, 4226777, 4226777, 4229551, 4359743, 4395467, 4403027, 4403027, 4415251, 4643627, 4672403, 4686391, 4713361, 4713361, 4766327, 4828277, 4828277, 4868641, 4868641, 4870847, 5008643, 5008643, 5016527, 5102959, 5143823, 5208377, 5208377, 5308181, 5328181, 5447881, 5447881, 5536127, 5652191, 5702887, 5734013, 5737577, 5942627, 5998463, 6011777, 6192721, 6192721, 6245147, 6359021, 6359021, 6368689, 6368689, 6374111, 6380207, 6469789, 6471931, 6494801, 6494801, 6494801, 6544561, 6544561, 6571601, 6580549, 6580549, 6671611, 6735007, 6755251, 6759751, 6884131, 6976201, 6986251, 6989569, 7064963, 7067171, 7174081, 7192007, 7225343, 7225343, 7353917, 7353917, 7369601, 7371079, 7398151, 7405201, 7405201, 7451153, 7473407, 7473407, 7493953, 7738363, 7879681, 7879681, 7950077, 7961801, 7961801, 8086231, 8259761, 8259761, 8390933, 8418827, 8502551, 8518127, 8655511, 8668607, 8834641, 8935877, 9031651, 9080191, 9191327, 9351647, 9353761, 9401893, 9401893, 9433883, 9476741, 9476741, 9493579, 9713027, 9793313, 9793313, 9808651, 9811891, 9811891, 9863461, 9863461, 9863461, 9863461, 9922337, 9922337, 10036223, 10339877, 10386241, 10386241, 10403641, 10403641, 10403641, 10403641, 10505701, 10604431, 10614563, 10679131, 10837601, 10837601, 10837601, 11205277, 11388007, 11460077, 11826383, 12007001, 12027023, 12040447, 12049409, 12049409, 12119101, 12119101, 12387799, 12446783, 12537527, 12572983, 12659363, 12958081, 12958081, 12958081, 12975691, 13012651, 13079221, 13158713, 13186637, 13277423, 13295281, 13404751, 13455077, 13455077, 13464467, 13870001, 14197823, 14575091, 14792971, 14892541, 14892541, 14892541, 15309737, 15350723, 15371201, 15576571, 15786647, 15811613, 16060277, 16173827, 16253551, 16403407, 16485493, 16485493, 16724927, 17040383, 17068127, 17288963, 17551883, 17791523, 18673201, 18673201, 18673201, 18673201, 18736381, 18818243, 18888379, 18888379, 19752767, 20018627, 20234341, 20234341, 20261251, 20261251, 20410207, 20412323, 20551301, 20551301, 20621567, 20623969, 20684303, 20754049, 20754049, 21215801, 21511043, 21574279, 21692189, 21692189, 21711583, 21783961, 21843007, 21988961, 22187791, 22361327, 22591301, 22591301, 22591301, 22634569, 22660007, 22669501, 22669501, 22669501, 22924943, 22994371, 22994371, 23307377, 23307377, 23561399, 23581277, 24151381, 24151381, 24157817, 24157817, 24493061, 24493061, 24550241, 24550241, 24681023, 24781423, 24930881, 24930881, 24974777, 24974777, 25183621, 25183621, 25532501, 25532501, 25707841, 25957231, 26118377, 26992877, 27012001, 27012001, 27012001, 27012001, 27085451, 28785077, 28985207, 29242127, 29354723, 29395277, 29395277, 30008483, 31504141, 32012963, 32060027, 32683201, 32683201, 32815361, 32817151, 33385283, 33796531, 33999491, 33999491, 34175777, 34175777, 34433423, 35798491, 35798491, 36307981, 36342653, 37123421, 37510019, 38415203, 38850173, 39088169, 39139127, 39850127, 40208027, 40747877, 40928627, 42149971, 42389027, 42399451, 42702661, 42702661, 43687877, 44166407, 44166407, 45768251, 46094401, 46112921, 46112921, 46114921, 46114921, 46114921, 46114921, 46344377, 46621583, 46672291, 46777807, 47253781, 47728501, 47728501, 48274703, 49019851, 49476377, 49476377, 49863661, 50808383, 50823151, 51803761, 51803761, 51876301, 53406863, 53655551, 55621763, 55681841, 55681841, 55830251, 56070143, 56972303, 57113717, 60186563, 62062883, 65415743, 70358543, 72897443, 73925603, 74442383, 75821503, 78110243, 78478943, 79624621, 83983073, 85423337, 89075843, 93663683, 93663683, 95413823, 97180163, 118901521, 121543501, 142030331, 224056801, 241924073, 246858841, 247679023, 388148903, 425399633, 429718411, 485989067, 732773791, 841980289, 957600541, 1312939321, 1706314037, 1932942527, 1952566309, 2166124801, 2166249691, 2244734413, 3173584391, 3383791321, 3383791321, 3406661927, 3585571907, 3807749821, 3807749821, 3938826767, 4250132963, 4293281521, 4369513223, 4598585921, 4610083201, 5073193501, 5374978561, 5410184641, 5802147391, 6317014703, 6390421291, 6486191209, 6666202787, 7917170801, 7917170801, 8631989203, 8645365081, 9340061821, 9506984911, 10193270401, 10490001721, 10521133201, 10908573077, 11384387281, 11851534697, 11851534697, 12182626763, 12525647327, 14678225269, 15216199501, 19770082847, 19941055289, 20286012751, 21380110489, 21936153271, 25933744367, 30550875623, 32376761983, 32855188591, 34933139161, 35646833933, 35646833933, 41898691223, 44912519441, 47075139721, 48306406891, 48568811171, 51068212561, 51489442351, 52396612381, 52396612381, 60804014251, 70504918721, 70504918721, 71432012629, 73817444191, 80952788071, 84654526967, 192813486181, 309385004989, 314101265081, 384655562873, 845776459637, 4211881766333, 4254641987311, 4382720043971, 45663814702501, 55216945762217, 79511946282173, 295569290441221, 838164471500267