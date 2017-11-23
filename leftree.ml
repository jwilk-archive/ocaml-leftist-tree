(* Copyright © 2004 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

type 'a leftree = LT_Empty | LT_Node of 'a * int * 'a leftree * 'a leftree;;

let lt_empty = LT_Empty;;
let lt_single v = LT_Node (v, 0, LT_Empty, LT_Empty);;

let lt_height t = match t with 
  LT_Empty -> -1 |
  LT_Node (_, height, _, _) -> height;;

let rec lt_merge_simple t1 t2 = match (t1, t2) with
  (LT_Empty, _) -> t2 |
  (_, LT_Empty) -> t1 |
  (LT_Node (v1, h1, l1, r1), LT_Node (v2, h2, l2, r2)) ->
    if v1 < v2 then
      let rest = lt_merge_simple r1 t2 in
        LT_Node(v1, 1 + lt_height rest, l1, rest)
    else
      let rest = lt_merge_simple t1 r2 in
        LT_Node(v2, 1 + lt_height rest, l2, rest);;

let rec lt_merge_fix t = match t with
  LT_Empty -> LT_Empty |
  LT_Node (v, h, l, r) ->
    let r = lt_merge_fix r in
    let lh = lt_height l and rh = lt_height r in
      if rh <= lh then
        LT_Node (v, 1 + rh, l, r)
      else
        LT_Node (v, 1 + lh, r, l);;

let lt_merge t1 t2 = lt_merge_fix (lt_merge_simple t1 t2);;

let lt_add t v = lt_merge t (lt_single v);;

let rec lt_add_list t vlist = match vlist with
  [] -> t |
  head::tail -> lt_add_list (lt_add t head) tail;;

let rec lt_create vlist = lt_add_list lt_empty vlist;;

let rec lt_top t = match t with
  LT_Empty -> raise(Failure "lt_top") |
  LT_Node (v, _, _, _) -> v;;

let rec lt_pop t = match t with
  LT_Empty -> raise(Failure "lt_pop") |
  LT_Node (_, _, l, r) -> lt_merge l r;;

let rec lt_print_helper t spc = match t with
  LT_Empty -> "" |
  LT_Node (v, _, l, r) ->
    (Printf.sprintf "%s%-4d\n" spc v) ^
    (lt_print_helper l (spc ^ "|   ")) ^
    (lt_print_helper r (spc ^ "|   "));;

let lt_print t =
  Printf.printf "%s" (lt_print_helper t "");;

let args = List.map int_of_string (List.tl (Array.to_list Sys.argv)) in
  let argtree = lt_create args in
    lt_print argtree;;

(* vim: set et ts=2 sts=2 sw=2 inde=-1: *)
