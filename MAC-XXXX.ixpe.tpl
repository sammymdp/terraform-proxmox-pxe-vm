#!ipxe

set media_root ${media_root}

set kernel_loc $${media_root}/${kernel_name}
set initrd_loc $${media_root}/${initrd_name}

%{if length(custom_lines) > 0 }
%{for line in custom_lines}
${line}
%{endfor}
%{endif}

set cmdline_args ${cmdline_args}

echo boot args
echo kernel $${kernel_loc} $${cmdline_args}
echo initrd $${initrd_loc}

imgfree
kernel $${kernel_loc} $${cmdline_args}
initrd $${initrd_loc}
imgstat
boot
