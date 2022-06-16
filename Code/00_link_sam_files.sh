for i in `cat /projects/rpci/joyceohm/pnfioric/list_of_RRBS_IDs.txt`; do
	echo $i
	cd /projects/rpci/joyceohm/RQ020887/RQ020887-Ohm_RRBS/output/bismark/${i}
	ln -s /projects/rpci/joyceohm/RQ020887/RQ020887-Ohm_RRBS/output/bismark/${i}/${i}*001_val_1.fq_trimmed_bismark_bt2_pe.sam /projects/rpci/joyceohm/pnfioric/RRBS_samfile_links/${i}_001_val_1.fq_trimmed_bismark_bt2_pe.sam
done
