import React, { Component } from "react";
import PropTypes from "prop-types";
import { HashRouter, Route, Switch } from "react-router-dom";
import {
  MuiThemeProvider,
  createMuiTheme,
  withStyles
} from "material-ui/styles";
import blue from "material-ui/colors/blue";
import purple from "material-ui/colors/purple";
import CssBaseline from "material-ui/CssBaseline";

import Home from "./home";

// A theme with custom primary and secondary color.
// It's optional.
const theme = createMuiTheme({
  palette: {
    primary: {
      light: blue[300],
      main: blue[500],
      dark: blue[700]
    },
    secondary: {
      light: purple[300],
      main: purple[500],
      dark: purple[700]
    },
    type: "light"
  }
});

const styles = theme => ({
  root: {
    flexGrow: 1,
    zIndex: 1,
    overflow: "hidden",
    position: "relative",
    display: "flex",
    width: "100%"
  },
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    backgroundColor: theme.palette.background.light,
    padding: theme.spacing.unit * 3
  }
});

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { classes } = this.props;
    return (
      <MuiThemeProvider theme={theme}>
        <CssBaseline />
        <HashRouter>
          <div className={classes.root}>
            <Switch>
              <Route path="/" component={Home} />
            </Switch>
          </div>
        </HashRouter>
      </MuiThemeProvider>
    );
  }
}

App.propTypes = {
  classes: PropTypes.object.isRequired
};

export default withStyles(styles)(App);
