vim.opt.makeprg = 'pylint --reports=no --output-format=text --msg-template="{path}:{line}:{column}:{C}:[{msg}]" %'
vim.opt.errorformat = '%f:%l:%c:%t:[%m]'
