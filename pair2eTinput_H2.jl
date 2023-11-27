#!/bin/julia
using DelimitedFiles

function append(fname, str)
    file = open(fname, "a")
    write(file, str * "\n")
    close(file)
end

# Write the input for a H2-molecule
function write_input1(fname, r1, r2, λ, ω, nph, hf_method="hf", posthf_method="ccsd")
    append(fname, "- system")
    append(fname, "    multiplicity: 1")
    append(fname, "")
    append(fname, "- do")
    append(fname, "    ground state")
    append(fname, "")
    append(fname, "- memory")
    append(fname, "    available: 54")
    append(fname, "")
    append(fname, "- method")
    append(fname, "    $hf_method")
    append(fname, "    $posthf_method")
    append(fname, "")
    append(fname, "- solver cholesky")
    append(fname, "    threshold: 1.0d-12")
    append(fname, "")
    append(fname, "- solver scf")
    append(fname, "    gradient threshold: 1.0d-12")
    append(fname, "")
    append(fname, "- solver cc gs")
    append(fname, "    omega threshold: 1.0d-10")
    append(fname, "    diis dimension: 50")
    append(fname, "")
    if occursin("fci", posthf_method)
        append(fname, "- solver ci")
        append(fname, "    states: 1")
        append(fname, "    residual threshold: 1.0d-7")
        append(fname, "")
    end
    if (nph != 0)
        append(fname, "- boson")
        append(fname, "    interaction type: photon")
        append(fname, "    modes: 1")
        append(fname, "    boson states: {$nph}") # T = T_el + S_el_1 + Gamma_1 + Gamma_2
        append(fname, "    polarization: {1.0, 0.0, 0.0}")
        append(fname, "    coupling: {$λ}")
        append(fname, "    frequency: {$ω}")
        append(fname, "")
    end
    append(fname, "- geometry")
    append(fname, "basis: aug-cc-pvdz")
    append(fname, "H $(r1[1]) $(r1[2]) $(r1[3])")
    append(fname, "H $(r2[1]) $(r2[2]) $(r2[3])")
end

# Write the input for a H2-dimer
function write_input2(fname, r1, r2, r3, r4, λ, ω, nph, hf_method="hf", posthf_method="ccsd")
    append(fname, "- system")
    append(fname, "    multiplicity: 1")
    append(fname, "")
    append(fname, "- do")
    append(fname, "    ground state")
    append(fname, "")
    append(fname, "- memory")
    append(fname, "    available: 54")
    append(fname, "")
    append(fname, "- method")
    append(fname, "    $hf_method")
    append(fname, "    $posthf_method")
    append(fname, "")
    append(fname, "- solver cholesky")
    append(fname, "    threshold: 1.0d-12")
    append(fname, "")
    append(fname, "- solver scf")
    append(fname, "    gradient threshold: 1.0d-12")
    append(fname, "")
    append(fname, "- solver cc gs")
    append(fname, "    omega threshold: 1.0d-10")
    append(fname, "    diis dimension: 50")
    append(fname, "")
    if occursin("fci", posthf_method)
        append(fname, "- solver ci")
        append(fname, "    states: 1")
        append(fname, "    residual threshold: 1.0d-7")
        append(fname, "")
    end
    if (λ != 0.0)
        append(fname, "- boson")
        append(fname, "    interaction type: photon")
        append(fname, "    modes: 1")
        append(fname, "    boson states: {$nph}") # T = T_el + S_el_1 + Gamma_1 + Gamma_2
        append(fname, "    polarization: {1.0, 0.0, 0.0}")
        append(fname, "    coupling: {$λ}")
        append(fname, "    frequency: {$ω}")
        append(fname, "")
    end
    append(fname, "- geometry")
    append(fname, "basis: aug-cc-pvdz")
    append(fname, "H $(r1[1]) $(r1[2]) $(r1[3])")
    append(fname, "H $(r2[1]) $(r2[2]) $(r2[3])")
    append(fname, "H $(r3[1]) $(r3[2]) $(r3[3])")
    append(fname, "H $(r4[1]) $(r4[2]) $(r4[3])")
end


function main()
    data = readdlm("pair-config-120k")
    λ = 0.1
    ω = 0.5

    for (hf_method, posthf_method) in zip(["hf", "hf", "hf"], ["ccsd", "ccsd(t)", "fci"])
        nph = 0
        path = mkpath("$(posthf_method)_input1")
        for i = 1:2:length(data[:,1])
            r1 = data[i, :]
            r2 = data[i+1, :]
            fname = path * "/$(i).inp"
            rm(fname, force=true)
            write_input1(fname, r1, r2, λ, ω, nph, hf_method, posthf_method)
        end

        path = mkpath("$(posthf_method)_input2")
        for i = 1:4:length(data[:,1])
            r1 = data[i, :]
            r2 = data[i+1, :]
            r3 = data[i+2, :]
            r4 = data[i+3, :]
            fname = path * "/$(i).inp"
            rm(fname, force=true)
            write_input2(fname, r1, r2, r3, r4, λ, ω, nph, hf_method, posthf_method)
        end
    end

    for (hf_method, posthf_method, nph) in zip(["qed-hf", "qed-hf"], ["qed-ccsd", "qed-fci"], [1,5])
        path = mkpath("$(posthf_method)-$(nph)_input1")
        for i = 1:2:length(data[:,1])
            r1 = data[i, :]
            r2 = data[i+1, :]
            fname = path * "/$(i).inp"
            rm(fname, force=true)
            write_input1(fname, r1, r2, λ, ω, nph, hf_method, posthf_method)
        end

        path = mkpath("$(posthf_method)-$(nph)_input2")
        for i = 1:4:length(data[:,1])
            r1 = data[i, :]
            r2 = data[i+1, :]
            r3 = data[i+2, :]
            r4 = data[i+3, :]
            fname = path * "/$(i).inp"
            rm(fname, force=true)
            write_input2(fname, r1, r2, r3, r4, λ, ω, nph, hf_method, posthf_method)
        end
    end
end

main()
