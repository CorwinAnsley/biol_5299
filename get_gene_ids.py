import csv

def get_gene_ids(var_file, column = 6):
    with open(var_file) as v_file:
        rows = csv.reader(v_file, delimiter='\t')
        for row in rows:
            print(row[column])

if __name__ == '__main__':
    get_gene_ids('.\data\Out_AmpB_NonSyn_variants.tsv')