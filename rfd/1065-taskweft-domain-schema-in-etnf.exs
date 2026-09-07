# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1065. `mix rfd.render` in rfd_dsl/ renders rfd/1065-taskweft-domain-schema-in-etnf/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1065 do
  use RFD.DSL

  rfd 1065, "Taskweft domain schema in essential tuple normal form" do
    state :discussion

    scope "RFD 1064's `domain.ex` and its 15,000 `problem.ex` files"

    attest_in :none

    decision ~S"""
    Design the `domain.ex`/`problem.ex` schema per essential tuple normal
    form (ETNF), from Darwen, Date, and Fagin (ICDT 2012). See
    `DETAILS.md` for the definition and its worked example. Three rules
    follow.
    
    1. `@variables` holds a trait map, keyed by trait name, one value per
       character, matching the `have`/`handle`/`loaded` pattern in RFD
       1044's `domain.ex`. The key is a superkey, so the map sits in BCNF.
    2. The trait taxonomy comes from the training data, not from
       preconceived categories. `capabilities` starts empty, and a
       domain action grows it as it resolves each trait value to a
       capability id. `problem.ex` stores a `:ref` to that id, never text.
    3. The resolve step runs inside taskweft, through the `HRR`/
       `HRR.Cleanup` library RFD 1021 already supplies, not through
       `WeftspunStudio.FactVector` outside it. A near-duplicate caption
       binds to the existing id, instead of creating a new one.
    
    Rule 2 and rule 3 remove the redundancy together. A functional
    dependency anchored on the capability id, a superkey, blocks the
    redundant tuple that ETNF targets, with no fixed enum to maintain.
    """

    problem ~S"""
    RFD 1064 asks Claude to inspect 15,000 dataset rows and write one
    `problem.ex` per row. Many rows share the same hair color, eye
    color, and pose, worded in different ways. A fixed trait list misses
    new values, and free text per row repeats the same fact many times.
    """

    related ~S"""
    RFD 1064 sets the domain/problem split. RFD 1037 gives the
    `:ref`/`capabilities` rules. RFD 1021 gives the `HRR` library. RFD
    1044 gives the worked `domain.ex` this schema follows.
    """

    details_title "Taskweft domain schema in essential tuple normal form"

    details "The definition", ~S"""
    Darwen, Date, and Fagin, "A Normal Form for Preventing Redundant
    Tuples in Relational Databases" (ICDT 2012), define essential tuple
    normal form (ETNF). A relation schema sits in ETNF when every tuple
    in every instance is essential. An essential tuple is a tuple no one
    can rebuild by projecting and rejoining the rest of the relation.
    
    Their syntactic test (Theorem 1.13) needs only two checks. The
    schema sits in Boyce-Codd normal form (BCNF), and some component of
    every declared join dependency is a superkey. ETNF sits strictly
    between fourth normal form (4NF) and fifth normal form (5NF, also
    called projection-join normal form). The paper proves ETNF removes
    tuple redundancy as well as 5NF does, though ETNF is easier to
    satisfy.
    """

    details "The worked example (the paper's Example 1.2)", ~S"""
    A relation R has attributes supplier (S), part (P), and project (J).
    A tuple (s, p, j) means supplier s supplies part p to project j. Two
    constraints hold: the join dependency ⋈{SP, PJ, JS}, and the
    functional dependency SP → J (a supplier and a part fix one project).
    
    5NF asks for R to split into three relations, one per pair of
    attributes, because of the join dependency alone. The paper shows
    R already carries no redundant tuple. The FD SP → J forces the
    join's third match before any tuple is added twice. R sits in 4NF
    and ETNF, not in 5NF, and needs no split.
    
    The lesson for this RFD: a functional dependency anchored on a
    superkey already blocks redundant tuples. Decomposing further, down
    to full 5NF, does no extra work against redundancy. It only adds more
    tables to maintain.
    """

    details "The schema sketch", ~S"""
    `domain.ex`, shared across all 15,000 problems, holds the trait map
    and one new action, `a_resolve_trait`. It has no fixed capability
    list. The list grows as Claude's vision inspection meets new values.
    
    ```elixir
    @variables %{
      trait: %{
        type: :ref,
        init: %{hair_color: nil, eye_color: nil, pose: nil, clothing: nil}
      }
    }
    
    @capabilities %{
      hair_color: %{},
      eye_color: %{},
      pose: %{},
      clothing: %{}
    }
    
    @actions %{
      a_resolve_trait: %{
        params: [:role, :caption_text],
        bind: [
          {:capability_id, {HRR.Cleanup, :resolve_or_create, ["{role}", "{caption_text}"]}}
        ],
        body: [
          %{pointer_set: "/trait/{role}", value: "{capability_id}"}
        ]
      }
    }
    ```
    
    `HRR.Cleanup.resolve_or_create/2` is the RFD 1021 library, called
    from inside taskweft, not from `WeftspunStudio.FactVector`. It binds
    the role and the caption text, and it checks the bound vector against
    the existing codebook. A near match returns the existing capability
    id. No match creates one and adds it to the codebook. Each `problem.ex`
    then calls `a_resolve_trait` once per trait, and stores only the
    returned `:ref`, never the caption text.
    """

    details "What this schema does not need", ~S"""
    No per-trait join table, no per-character-pair table, and no
    hand-maintained enum list. The 15,000 `problem.ex` files repeat only
    a capability id. Near-duplicate captions collapse to one id through
    `HRR.Cleanup`, so the redundant-tuple problem the paper's Example
    1.1 shows never appears here.
    """

    details "Source", ~S"""
    Darwen, H., Date, C. J., and Fagin, R. "A Normal Form for
    Preventing Redundant Tuples in Relational Databases." ICDT 2012,
    Berlin. https://openproceedings.org/2012/conf/icdt/DarwenDF12.pdf
    """

    drafted_by :ai
  end
end
