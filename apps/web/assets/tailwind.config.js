// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*web.ex',
    '../lib/*web/**/*.*ex'
  ],
  theme: {
    extend: {
      colors: {
        haroon: "#2c1a2c",
        "haroon-light": "#554155",
        "haroon-black": "#030001",
        rose: {
          50: "#f7f2f5",
          100: "#F1EDEF",
          200: "#DDD2D7",
          300: "#C8B6BF",
          400: "#9E808E",
          500: "#75495E",
          600: "#694255",
          700: "#462C38",
          800: "#35212A",
          900: "#23161C",
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
};
