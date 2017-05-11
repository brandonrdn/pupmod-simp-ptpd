Facter.add(:ptpd_version) do 
	setcode "ptpd2 -v | awk '{print $3}'"
end 
