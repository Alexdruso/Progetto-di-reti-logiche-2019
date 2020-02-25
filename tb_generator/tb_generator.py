from os.path import abspath, dirname

# Each element of the following list shall be a tuple of 3 elements:
# [0] shall be the description of the test bench
# [1] shall be a list of 8 ints containing the addresses of the working zones
# [2] shall be a list of ints containing the addresses to encode consecutively,
#     that is without performing a reset between them
test_benches = [
  ("first_wz_first_addr", [0, 4, 55, 31, 37, 45, 77, 91], [0]),
  ("first_wz_last_addr", [0, 4, 55, 31, 37, 45, 77, 91], [3]),
  ("last_wz_first_addr", [0, 4, 55, 31, 37, 45, 77, 91], [91]),
  ("last_wz_last_addr", [0, 4, 55, 31, 37, 45, 77, 91], [94]),
  ("first_not_in_wz", [0, 4, 55, 31, 37, 45, 77, 91], [95]),
  ("multiple_conversions", [0, 4, 55, 31, 37, 45, 77, 91], [3, 31, 95, 94, 3, 2, 2]),
  ("extreme_wzs", [0, 124, 72, 44, 55, 66, 77, 88], [0, 127]),
  ("all_offsets", [0, 4, 55, 31, 37, 45, 77, 91], [0, 1, 2, 3]),
  ("blurred_borders", [0, 4, 8, 12, 16, 20, 24, 28], [3, 4, 7, 8, 11, 12, 15, 16, 19, 20, 23, 24, 27, 28]),
  ("same_encoding", [0, 124, 72, 44, 55, 66, 77, 88], [0, 0])
]

DIRNAME = dirname(abspath(__file__))

with open(f"{DIRNAME}/assets/tb_base.txt", "r") as f:
	TB_BASE_RAW = f.read()

with open(f"{DIRNAME}/assets/tb_test_case_base.txt", "r") as f:
	TB_TEST_CASE_BASE_RAW = f.read()

for test_bench_i, test_bench in enumerate(test_benches):
  print(f"Computing test bench {test_bench_i+1}...")
  test_bench_descr = test_bench[0]
  wzs = test_bench[1]
  test_cases = test_bench[2]

  test_cases_text = []
  for test_case_i, test_case in enumerate(test_cases):
    expected_output_int = test_case
    expected_output_text = f"0{test_case:07b}"
    for wz, wz_base in enumerate(wzs):
      offset = test_case - wz_base
      if 0 <= offset < 4:
        expected_output_int = 2**7 + wz*16 + 2**offset
        expected_output_text = f"1-{wz:03b}-{2**offset:04b}"
        break
    test_cases_text.append(TB_TEST_CASE_BASE_RAW.format(
      test_case_number=test_case_i+1,
      test_case_in_int=test_case,
      test_case_out_int=expected_output_int,
      test_case_out_bin_text=expected_output_text
    ))

  test_bench_text = TB_BASE_RAW.format(
    test_bench_descr=test_bench_descr,
    test_bench_ram="\n".join([f"{i} => std_logic_vector(to_unsigned({v} , 8))," for i, v in enumerate(wzs)]),
    test_bench_body="\n\n----------\n\n".join(test_cases_text)
  )

  out_filename = f"out/tb_custom{test_bench_i+1:03d}_{test_bench_descr}.vhd"
  with open(f"{DIRNAME}/{out_filename}", "w") as f:
    print(f"Writing {out_filename}...\n")
    f.write(test_bench_text)

print("That's all, folks!")