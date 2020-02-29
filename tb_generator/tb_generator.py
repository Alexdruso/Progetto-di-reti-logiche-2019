from os.path import abspath, dirname
from random import randint

# Each element of the following list shall be a tuple of 3 elements:
# [0] shall be the description of the test bench
# [1] shall be a list of 8 ints containing the addresses of the working zones
# [2] shall be a list of ints containing the addresses to encode consecutively,
#     that is without performing a reset between them
test_benches = { 
  "main_tb": [
    ("weird", [99, 124, 107, 120, 8, 126, 40, 20], [111]),
    ("first_wz_first_addr", [0, 4, 55, 31, 37, 45, 77, 91], [0]),
    ("first_wz_last_addr", [0, 4, 55, 31, 37, 45, 77, 91], [3]),
    ("last_wz_first_addr", [0, 4, 55, 31, 37, 45, 77, 91], [91]),
    ("last_wz_last_addr", [0, 4, 55, 31, 37, 45, 77, 91], [94]),
    ("first_not_in_wz", [0, 4, 55, 31, 37, 45, 77, 91], [95]),
    ("multiple_conversions", [0, 4, 55, 31, 37, 45, 77, 91], [3, 31, 95, 94, 3, 2, 2]),
    ("extreme_wzs", [0, 124, 72, 44, 55, 66, 77, 88], [0, 127]),
    ("extreme_addr_not_in_wzs", [4, 120, 72, 44, 55, 66, 77, 88], [0, 127]),
    ("all_offsets", [0, 4, 55, 31, 37, 45, 77, 91], [0, 1, 2, 3]),
    ("blurred_borders", [0, 4, 8, 12, 16, 20, 24, 28], [3, 4, 7, 8, 11, 12, 15, 16, 19, 20, 23, 24, 27, 28]),
    ("same_encoding", [0, 124, 72, 44, 55, 66, 77, 88], [0, 0])
  ],
  "random_tb": [(f"random_{i}", [randint(0, 127) for _ in range(8)], [randint(0, 127) for _ in range(randint(1, 50))]) for i in range(10)]
}


DIRNAME = dirname(abspath(__file__))

with open(f"{DIRNAME}/assets/tb_base.txt", "r") as f:
	TB_BASE_RAW = f.read()

with open(f"{DIRNAME}/assets/tb_test_case_base.txt", "r") as f:
	TB_TEST_CASE_BASE_RAW = f.read()

with open(f"{DIRNAME}/assets/tb_set_ram_cell_base.txt", "r") as f:
	TB_SET_RAM_CELL_BASE_RAW = f.read()

with open(f"{DIRNAME}/assets/tb_setup_ram_base.txt", "r") as f:
	TB_SETUP_RAM_BASE_RAW = f.read()

for test_bench_i, (test_bench_name, test_bench) in enumerate(test_benches.items()):
  print(f"Computing test bench {test_bench_name}...")

  test_bench_text = []

  for test_bench_section_i, test_bench_section in enumerate(test_bench):
    test_bench_descr = test_bench_section[0]
    wzs = test_bench_section[1]
    test_cases = test_bench_section[2]

    print(f"Computing section {test_bench_descr}...")

    ram_cells_setup_text = "\n".join([TB_SET_RAM_CELL_BASE_RAW.format(
      addr_in_int=addr_in_int,
      data_in_int=data_in_int
    ) for addr_in_int, data_in_int in enumerate(wzs+[test_cases[0]])]) if test_bench_section_i > 0 else "--RAM gia' inizializzata"
    ram_setup_text = TB_SETUP_RAM_BASE_RAW.format(
      ram_setup_body=ram_cells_setup_text
    )

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
      test_case_ram_cell_text = TB_SET_RAM_CELL_BASE_RAW.format(
        addr_in_int=8,
        data_in_int=test_case
      ) if test_bench_section_i > 0 or test_case_i > 0 else "--RAM gia' inizializzata"
      test_cases_text.append(TB_TEST_CASE_BASE_RAW.format(
        test_case_number=f"{test_bench_section_i+1}.{test_case_i+1}",
        test_case_ram_setup=test_case_ram_cell_text,
        test_case_out_int=expected_output_int,
        test_case_out_bin_text=expected_output_text
      ))
    test_bench_text.append(f"--test section: {test_bench_descr}")
    test_bench_text.append(ram_setup_text)
    test_bench_text.append("\n\n----------\n\n".join(test_cases_text))

  test_bench_text = TB_BASE_RAW.format(
    test_bench_descr=test_bench_descr,
    test_bench_ram="\n".join([f"{i} => std_logic_vector(to_unsigned({v} , 8))," for i, v in enumerate(test_bench[0][1]+[test_bench[0][2][0]])]),
    test_bench_body="\n".join(test_bench_text)
  )

  out_filename = f"out/tb_custom{test_bench_i+1:03d}_{test_bench_name}.vhd"
  with open(f"{DIRNAME}/{out_filename}", "w") as f:
    print(f"Writing {out_filename}...\n")
    f.write(test_bench_text)

print("That's all, folks!")