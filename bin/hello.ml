[@@@ai_disclosure "ai-generated"]
[@@@ai_model "claude-fable-5-1"]
[@@@ai_provider "Anthropic"]

(* [stack_] allocates the tuple on the stack and [exclave_] hands it back in
   the caller's frame, so [make_pair] never touches the heap. Both keywords
   are OxCaml extensions: this file does not compile on upstream OCaml. *)
let make_pair x y = exclave_ stack_ (x, y)

let () =
  let a, b = make_pair 20 22 in
  Printf.printf "Hello from OxCaml %s! %d + %d = %d\n" Sys.ocaml_version a b
    (a + b)
