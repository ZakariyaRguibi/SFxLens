export default {
  title: 'SFxLens API Documentation',
  description: 'Apex documentation for the SFxLens project',
  base: '/SFxLens/',
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'API Reference', link: '/markdown/' },
      { text: 'Changelog', link: '/changelog/changelog' },
      { text: 'Code Analyzer', link: '/code-analyzer/' },
    ],
    sidebar: {
      '/markdown/': [
        {
          text: 'API Documentation',
          items: [
            { text: 'Index', link: '/markdown/' }
          ]
        }
      ]
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/ZakariyaRguibi/SFxLens' }
    ],
    footer: {
      message: 'Generated with ApexDocs and VitePress',
      copyright: 'Copyright © SFxLens Project'
    }
  }
}
