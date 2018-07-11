import _ from 'lodash';
import { FETCH_PROJECTS } from '../actions';

export default function(state = {}, action) {
  switch(action.type) {
    case FETCH_PROJECTS:
      return _.mapKeys(action.payload.data, 'id');
    default:
      return state;
  }
}