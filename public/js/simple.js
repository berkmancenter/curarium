/**
 * Very simple basic rule set
 *
 * Allows
 *    <i>, <em>, <b>, <strong>, <p>, <div>, <a href="http://foo"></a>, <br>, <span>, <ol>, <ul>, <li>
 *
 * For a proper documentation of the format check advanced.js
 */
var ruleset = {
  
  classes: {
  	"wysiwyg-text-align-center": 1,
  	"wysiwyg-text-align-left": 1,
    "wysiwyg-text-align-right": 1
  },
  tags: {
    strong: {},
    b:      {},
    i:      {},
    em:     {},
    br:     {},
    p:      {},
    div:    {},
    span:   {},
    ul:     {},
    ol:     {},
    li:     {},
    a:      {
      set_attributes: {
        target: "_blank",
        rel: "nofollow"
      },
      check_attributes: {
        href:   "url" // important to avoid XSS
      }
    },
    img: {
        check_attributes: {
            width: "numbers",
            alt: "alt",
            src: "url",
            height: "numbers"
        }
    }
  }
};