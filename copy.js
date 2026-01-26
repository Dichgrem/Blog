(function() {
    document.querySelectorAll('pre code').forEach((codeBlock) => {
        const pre = codeBlock.parentElement;
        
        if (pre.querySelector('.copy-button')) {
            return;
        }
        
        const copyButton = document.createElement('button');
        copyButton.className = 'copy-button';
        copyButton.textContent = '复制';
        copyButton.setAttribute('aria-label', '复制代码');
        copyButton.setAttribute('type', 'button');
        
        copyButton.addEventListener('click', () => {
            navigator.clipboard.writeText(codeBlock.textContent.trimEnd()).then(() => {
                copyButton.textContent = '已复制!';
                copyButton.classList.add('copied');
                
                setTimeout(() => {
                    copyButton.textContent = '复制';
                    copyButton.classList.remove('copied');
                }, 2000);
            }).catch((err) => {
                copyButton.textContent = '失败';
                setTimeout(() => {
                    copyButton.textContent = '复制';
                }, 2000);
            });
        });
        
        pre.appendChild(copyButton);
    });
})();
