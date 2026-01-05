export type AuthorizedInfo = {
  user_id: string;
  session_id: string;
  sub: string;
  client_id: string;
};

export declare function Authorized(): AuthorizedInfo;
