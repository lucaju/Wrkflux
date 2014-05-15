package model {
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class PHPGateWay {
		
		//****************** Proprieties ****************** ****************** ****************** 
		
		static public const PATH					:String = "http://labs.fluxo.art.br/wrkflux/php/";
		
		static protected const SignIn				:String = "getUser.php";
		static protected const SignUp				:String = "insertUser.php";
		static protected const UpadteProfile		:String = "updateUserProfile.php";
		static protected const ForgotPass			:String = "forgotPass.php";
		
		static protected const ReceiveFile			:String = "upload.php";
		
		static protected const GetWorkflows			:String = "getWorkflows.php";
		static protected const DeleteWorkflow		:String = "deleteWorkflow.php"
		
		static protected const InsertWorkflow		:String = "insertWorkflow.php";
		static protected const GetWorkflowBuildInfo	:String = "getWorkflowBuildInfo.php";
		static protected const UpdateWorkflowBuild	:String = "updateWorkflowBuild.php";
		
		static protected const GetWorkflow			:String = "getWorkflow.php";
		static protected const InsertDoc			:String = "insertDoc.php";
		static protected const InsertLogDoc			:String = "insertLogDoc.php";
		static protected const DeleteDoc			:String = "deleteDoc.php";
		static protected const GetDocLogs			:String = "getDocLogs.php";
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function PHPGateWay() {
			
		}
		
		
		//****************** STATIC PUBLIC METHODS - WORKFLUX ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get signIn():String {
			return PATH + SignIn;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get signUp():String {
			return PATH + SignUp;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get upadteProfile():String {
			return PATH + UpadteProfile;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get forgotPass():String {
			return PATH + ForgotPass;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function get getWorkflows():String {
			return PATH + GetWorkflows;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function get deleteWorkflow():String {
			return PATH + DeleteWorkflow;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function get receiveFile():String {
			return PATH + ReceiveFile;
		}
		
		
		//****************** STATIC PUBLIC METHODS - BUILDER ****************** ****************** ****************** 
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function createWorkflow():String {
			return PATH + InsertWorkflow;		
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function loadWorkflow():String {
			return PATH + GetWorkflowBuildInfo;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function UpdateWorkflow():String {
			return PATH + UpdateWorkflowBuild;
		}
		
		
		//****************** STATIC PUBLIC METHODS - WORKFLOW ****************** ****************** ****************** 
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function getWorkflow():String {
			return PATH + GetWorkflow;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function addDocument():String {
			return PATH + InsertDoc;
			
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function addLog():String {
			return PATH + InsertLogDoc;;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function removeDoc():String {
			return PATH + DeleteDoc;;
		}
		
		/**
		 *
		 * @return 
		 * 
		 */
		static public function loadDocLog():String {
			return PATH + GetDocLogs;
		}
	}
}