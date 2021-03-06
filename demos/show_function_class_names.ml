open Common
open Ast_php

let pr_func_def func_def =
  let s = Ast_php.str_of_ident func_def.f_name in
  let info = Ast_php.info_of_ident func_def.f_name in
  let line = Parse_info.line_of_info info in
  pr2 (spf "Define function %s at line %d" s line)

let pr_class_def class_def =
  let s = Ast_php.str_of_ident class_def.c_name in
  let info = Ast_php.info_of_ident class_def.c_name in
  let line = Parse_info.line_of_info info in
  pr2 (spf "Define class %s at line %d" s line)

let show_function_calls file =
  let (asts2, _stat) = Parse_php.parse file in
  let asts = Parse_php.program_of_program2 asts2 in

    asts +> List.iter (fun toplevel ->
      match toplevel with
      | FuncDef func_def ->
        pr_func_def func_def
      | ClassDef class_def ->
        pr_class_def class_def;
        (unbrace class_def.c_body) +> List.iter (fun class_stmt ->
          match class_stmt with
            | Method func_def->
              pr_func_def func_def
            | _ -> ()
         )
      | (ConstantDef _|TypeDef _
        |NotParsedCorrectly _| FinalDef _ | StmtList _
        )
        -> ()
    )

let main =
  show_function_calls Sys.argv.(1)
