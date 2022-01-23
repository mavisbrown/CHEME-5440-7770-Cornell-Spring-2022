### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ a3101ae7-2699-43e7-aa28-332b0447bbc5
begin

	# Setup the Julia environment -
	using PlutoUI
	
	# setup paths -
	const _PATH_TO_NOTEBOOK = pwd()
	const _PATH_TO_DATA = joinpath(_PATH_TO_NOTEBOOK,"data")
	const _PATH_TO_FIGS = joinpath(_PATH_TO_NOTEBOOK,"figs")
	const _PATH_TO_SRC = joinpath(_PATH_TO_NOTEBOOK,"src")
	
	# return -
	nothing
end

# ╔═╡ 45e60528-7b8d-11ec-3aa3-65625ebbbfb2
md"""
### Introduction to Metabolism and Metabolic Engineering

Metabolic engineering is the practice of optimizing genetic and regulatory processes within cells to increase the cell's production of a desired molecule or protein of interest. 

Metabolic engineers manipulate the biochemical networks used by cells to convert raw materials into molecules necessary for the cell's survival. Metabolic engineering specifically seeks to:

1. Mathematically model biochemical networks, calculate the yield (product divided substrate) of useful products, and identify parts of the network that constrain the production of the products of interest. 
1. Use genetic engineering techniques to modify the biochemical network in order to relieve constraints limiting production. The modified network can then be modeled to calculate the new product yield, and to identify new constraints (back to 1).

Resources for biochemical network information:
* [Kanehisa M, Goto S. KEGG: kyoto encyclopedia of genes and genomes. Nucleic Acids Res. 2000 Jan 1;28(1):27-30. doi: 10.1093/nar/28.1.27. PMID: 10592173; PMCID: PMC102409.](https://www.genome.jp/kegg/)

* [Karp, Peter D et al. “The BioCyc collection of microbial genomes and metabolic pathways.” Briefings in bioinformatics vol. 20,4 (2019): 1085-1093. doi:10.1093/bib/bbx085](https://pubmed.ncbi.nlm.nih.gov/29447345/)

* [Gama-Castro, Socorro et al. “RegulonDB version 9.0: high-level integration of gene regulation, coexpression, motif clustering and beyond.” Nucleic acids research vol. 44,D1 (2016): D133-43. doi:10.1093/nar/gkv1156](https://pubmed.ncbi.nlm.nih.gov/26527724/)
"""

# ╔═╡ 96d697e1-d190-4d9b-aeb8-53466cc1cce2
md"""
__Fig 1.__ The overall metabolic map from the KEGG database. Each dot (_node_) is a metabolite, each line (_edge_) is a metabolic reaction. 
"""

# ╔═╡ 87c121a0-91ed-436f-a981-a8a5198c3226
PlutoUI.LocalResource(joinpath(_PATH_TO_FIGS,"KEGG-map01100.png"))

# ╔═╡ 2e67cdc9-9cd4-4a20-9ac7-1ecfd4b46967
md"""
### Example products and processes 
"""

# ╔═╡ 04095813-6cfc-4983-9109-3a83df4b9b85
md"""
### Material balances in the continumn well-mixed limit

Let's consider the action of the enzyme [phosphofructokinase (PFK)](https://www.genome.jp/entry/2.7.1.11) shown in Fig XX. This "simple" reaction, ATP + D-fructose 6-phosphate = ADP + D-fructose 1,6-bisphosphate, contains all the features of the much larger problem of optimizing the metabolism of an entire cell. Thus, let's use this example to motivate what we'll study in the first half of the course. We'll begin by writing down some material balances.
"""

# ╔═╡ c8915f0f-b770-4bdb-9a58-d410e0036660
md"""
__Fig 2.__ The overall metabolic map from the KEGG database. Each dot (_node_) is a metabolite, each line (_edge_) is a metabolic reaction. 
"""

# ╔═╡ 67c3d6e8-8238-48de-a088-80ab1ccb9bb7
PlutoUI.LocalResource(joinpath(_PATH_TO_FIGS, "KEGG-Ecoli-MG1655-Glycolysis.gif"))

# ╔═╡ f1fb1e93-c186-4fc2-8bdb-2994ebefde8f
md"""

##### General case

Let's consider the general case in which we have $\mathcal{R}$ chemical reactions and $\mathcal{M}$ metabolites (chemical species) operating in some well-mixed physical (or logical) control volume $\Omega$. In the general continuum well-mixed limit, we could write species mol balances around each chemical species $i$ that take the form:

$$\frac{d}{dt}\left(C_{i}\beta\right) = \sum_{s=1}^{\mathcal{S}}d_{is}\dot{n}_{is} + \left(\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\hat{r}_{j}\right)\beta + \qquad{i=1,2,\dots,\mathcal{M}}$$

where $C_{i}$ denotes the concentration (or number density) of species $i$ calculated with respect to a _system basis_ $\beta$. 
The first set of terms on the right-hand side denotes the rate of physical or _logical_ transport (units: mol or number per unit time) of chemical species $i$ into or from control volume $\Omega$, where $d_{is}$ denotes a direction parameter. The second set of terms denote the chemical reaction terms which describe the rate of production (consumption) of species $i$ by enzyme-catalyzed chemical reaction(s) $j$. The  net rate per unit $\beta$ is denoted by $\hat{r}_{j}$, while $\sigma_{ij}$ denotes the stoichiometric coefficient relating species $i$ with reaction $j$:

* A stoichiometric coefficient $\sigma_{ij}$ > 0 implies that metabolite $i$ is __produced__ by reaction $j$
* A stoichiometric coefficient $\sigma_{ij}$  = 0 implies that metabolite $i$ is __not connected__ to reaction $j$
* A stoichiometric coefficient $\sigma_{ij}$ < 0 implies that metabolite $i$ is __consumed__ by reaction $j$

##### Example: Three reaction pathway (constant volume)

We can start from the general model shown above, and throw out terms to describe the action of a three reaction pathway reaction catalyzed by [phosphofructokinase (PFK)](https://www.genome.jp/entry/2.7.1.11), [fructose-bisphosphate aldolase (FBA)](https://www.kegg.jp/entry/4.1.2.13) and [triose-phosphate isomerase (TPI)](https://www.kegg.jp/entry/5.3.1.1). Suppose we consider a batch _in-vitro_ system operating in a reaction mixture with V = 15$\mu$L (constant). In this case, we have no physical transport terms, $\mathcal{R}$ = 3 and $\mathcal{M}$ = 6 (f6p, f16bp, dhap, ga3p, atp, adp). 
The balance equations become:

$$\frac{dC_{i}}{dt} = \left(\sum_{j=1}^{\mathcal{R} = 3}\sigma_{ij}\hat{r}_{j}\right)\qquad{i=1,\dots,\mathcal{M} = 6}$$

"""

# ╔═╡ 64329198-85ce-47ea-a8d9-e664481a9658
html"""
<style>
main {
    max-width: 1200px;
    width: 75%;
    margin: auto;
    font-family: "Roboto, monospace";
}

a {
    color: blue;
    text-decoration: none;
}

.H1 {
    padding: 0px 30px;
}
</style>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.30"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─45e60528-7b8d-11ec-3aa3-65625ebbbfb2
# ╟─96d697e1-d190-4d9b-aeb8-53466cc1cce2
# ╟─87c121a0-91ed-436f-a981-a8a5198c3226
# ╟─2e67cdc9-9cd4-4a20-9ac7-1ecfd4b46967
# ╟─04095813-6cfc-4983-9109-3a83df4b9b85
# ╟─c8915f0f-b770-4bdb-9a58-d410e0036660
# ╟─67c3d6e8-8238-48de-a088-80ab1ccb9bb7
# ╟─f1fb1e93-c186-4fc2-8bdb-2994ebefde8f
# ╠═a3101ae7-2699-43e7-aa28-332b0447bbc5
# ╟─64329198-85ce-47ea-a8d9-e664481a9658
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
